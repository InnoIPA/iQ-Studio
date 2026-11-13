#!/bin/bash

# --- Default Values ---
TEST_DURATION=300
WARMUP_TIME=180
OUTPUTPATH="./output.txt"
CONFIG_FILE="config_nv.json"
VIDEO_FILE=""
CHANNELS=""
GEN_CONFIG=""
INPUT_PLATFORM="auto"
VENV_DIR="venv"

# --- Cleanup Function ---
cleanup() {
    echo -e "\n[INFO] Interrupt received. Cleaning up background processes..."
    jobs -p | xargs -r kill
    exit 1
}

trap cleanup SIGINT SIGTERM
trap '[ -n "$GEN_CONFIG" ] && rm -f "$GEN_CONFIG"' EXIT

# --- Help Message ---
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --test_time SECS     Total test duration (default: 300)"
    echo "  --warmup_time SECS   Warmup time before monitoring (default: 180)"
    echo "  --output PATH        Output file path (default: ./output.txt)"
    echo "  --video PATH         NVIDIA only: video file for every channel (default: the video in config_nv.json)"
    echo "  --channels N         NVIDIA only: number of channels, 1 to 16 (default: the number in config_nv.json)"
    echo "  --platform TYPE      Platform: auto, nv, qcom (default: auto)"
    echo "                       qcom runs config.json in the iqs-streampipe Docker image; edit config.json to set the channels"
    echo "  --help               Display this help message"
    exit 1
}

# --- Parse Arguments ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --test_time) TEST_DURATION="$2"; shift 2 ;;
        --warmup_time) WARMUP_TIME="$2"; shift 2 ;;
        --output) OUTPUTPATH="$2"; shift 2 ;;
        --video) VIDEO_FILE="$2"; shift 2 ;;
        --channels) CHANNELS="$2"; shift 2 ;;
        --platform) INPUT_PLATFORM=$(echo "$2" | tr '[:upper:]' '[:lower:]'); shift 2 ;;
        --help) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# --- Validation ---
MONITOR_DURATION=$((TEST_DURATION - WARMUP_TIME))
if (( WARMUP_TIME >= TEST_DURATION )); then
  echo "[ERROR] warmup_time (${WARMUP_TIME}s) must be less than test_duration (${TEST_DURATION}s)" >&2
  exit 1
fi

# --- Platform Decision Logic ---
TARGET_PLATFORM="$INPUT_PLATFORM"
if [[ "$INPUT_PLATFORM" == "auto" ]]; then
    if command -v nvidia-smi &> /dev/null; then
        TARGET_PLATFORM="nv"
    else
        TARGET_PLATFORM="qcom"
    fi
fi
echo "Target Platform: $TARGET_PLATFORM"

if [[ "$TARGET_PLATFORM" == "qcom" ]]; then
    if [[ -n "$CHANNELS" || -n "$VIDEO_FILE" ]]; then
        echo "[ERROR] --channels and --video are only for the NVIDIA platform. For the Qualcomm platform, edit config.json." >&2
        exit 1
    fi
    if ! command -v iqs-launcher &> /dev/null; then
        echo "[ERROR] iqs-launcher not found. Run ./install.sh in the iQ-Studio repository root first." >&2
        exit 1
    fi
    if [ ! -f config.json ]; then
        echo "[ERROR] config.json not found. Run this script from benchmarks/iq-8275/multi-stream/iqs-streampipe." >&2
        exit 1
    fi
fi

if [[ -n "$CHANNELS" ]]; then
  if ! [[ "$CHANNELS" =~ ^[0-9]+$ ]] || (( CHANNELS < 1 || CHANNELS > 16 )); then
    echo "[ERROR] --channels must be a number from 1 to 16" >&2
    exit 1
  fi
fi
if [[ -n "$VIDEO_FILE" && ! -f "$VIDEO_FILE" ]]; then
  echo "[ERROR] Video file not found: $VIDEO_FILE" >&2
  exit 1
fi

# --- Environment Setup ---
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    if ! python3 -m venv "$VENV_DIR" || [ ! -f "$VENV_DIR/bin/activate" ]; then
        rm -rf "$VENV_DIR"
        echo "[ERROR] Cannot create the Python virtual environment. Install it with: sudo apt install python3-venv" >&2
        exit 1
    fi
    source "$VENV_DIR/bin/activate"
    pip3 install -r requirements.txt
else
    source "$VENV_DIR/bin/activate"
fi

# make sure the output folder and cleanup the output folder
mkdir -p "$(dirname "$OUTPUTPATH")"
> "$OUTPUTPATH"

# --- Execution ---
case "$TARGET_PLATFORM" in
    "nv")
        if [ ! -f "$CONFIG_FILE" ]; then echo "[ERROR] Config file not found: $CONFIG_FILE" >&2; exit 1; fi
        if [[ -n "$VIDEO_FILE" || -n "$CHANNELS" ]]; then
            # Build the config from the first stream of config_nv.json: same model, the chosen video, N channels.
            GEN_CONFIG="$(mktemp /tmp/config_nv_XXXXXX.json)"
            python3 - "$CONFIG_FILE" "$VIDEO_FILE" "${CHANNELS:-1}" > "$GEN_CONFIG" <<'PY'
import json, sys
template, video, channels = sys.argv[1], sys.argv[2], int(sys.argv[3])
base = json.load(open(template))["streams"][0]
streams = []
for i in range(channels):
    stream = dict(base)
    stream["id"] = i
    if video:
        stream["source_path"] = video
    streams.append(stream)
print(json.dumps({"streams": streams}, indent=4))
PY
            CONFIG_FILE="$GEN_CONFIG"
        fi
        # Write the test settings at the top of the output file (also printed on the screen).
        read -r CFG_CHANNELS CFG_VIDEO < <(python3 - "$CONFIG_FILE" <<'PY'
import json, sys
streams = json.load(open(sys.argv[1]))["streams"]
print(len(streams), streams[0]["source_path"])
PY
)
        {
            echo "=== Benchmark settings ==="
            echo "Date:        $(date '+%Y-%m-%d %H:%M:%S')"
            echo "Platform:    $TARGET_PLATFORM"
            echo "Channels:    $CFG_CHANNELS"
            echo "Video:       $CFG_VIDEO"
            echo "Warm-up:     ${WARMUP_TIME} s"
            echo "Test time:   ${TEST_DURATION} s (measurement window ${MONITOR_DURATION} s)"
            echo "=========================="
            echo
        } | tee -a "$OUTPUTPATH"
        export DISPLAY="${DISPLAY:-:0}"
        timeout "${TEST_DURATION}" ./nvidia/streampipe_nv -c "$CONFIG_FILE" -b --warmup_time "${WARMUP_TIME}" 1> >(tee -a "$OUTPUTPATH") &
        BENCH_PID=$!
        ;;
    "qcom")
        # Write the test settings at the top of the output file (also printed on the screen).
        read -r CFG_CHANNELS CFG_VIDEO < <(python3 - config.json <<'PY'
import json, sys
streams = json.load(open(sys.argv[1]))["streams"]
print(len(streams), streams[0]["source_path"])
PY
)
        {
            echo "=== Benchmark settings ==="
            echo "Date:        $(date '+%Y-%m-%d %H:%M:%S')"
            echo "Platform:    $TARGET_PLATFORM"
            echo "Channels:    $CFG_CHANNELS"
            echo "Video:       $CFG_VIDEO"
            echo "Warm-up:     ${WARMUP_TIME} s"
            echo "Test time:   ${TEST_DURATION} s (measurement window ${MONITOR_DURATION} s)"
            echo "=========================="
            echo
        } | tee -a "$OUTPUTPATH"
        echo "[INFO] Starting iqs-launcher (the Docker image is pulled on the first run)..."
        timeout "${TEST_DURATION}" iqs-launcher --autotag iqs-streampipe --other " -c config.json -b --warmup_time ${WARMUP_TIME}" 1> >(tee -a "$OUTPUTPATH") &
        BENCH_PID=$!
        ;;
    *)
        echo "[ERROR] Invalid platform: $TARGET_PLATFORM" >&2
        exit 1
        ;;
esac

sleep 0.5
if ! kill -0 "$BENCH_PID" 2>/dev/null; then
    echo "[ERROR] Benchmark process failed immediately. Exiting." >&2
    exit 1
fi

# --- Monitoring ---
echo "[INFO] Warming up for ${WARMUP_TIME}s..."
sleep "${WARMUP_TIME}"

if kill -0 $BENCH_PID 2>/dev/null; then
    echo "[INFO] Start monitoring for ${MONITOR_DURATION}s..."
    timeout "${MONITOR_DURATION}" ./venv/bin/python3 ./scripts/system_monitor.py 1> >(tee -a "$OUTPUTPATH")
else
    echo "[ERROR] Benchmark process failed to start or crashed during warmup." 2>&1
    exit 1
fi

echo "[SUCCESS] Benchmark completed. Results saved to $OUTPUTPATH"