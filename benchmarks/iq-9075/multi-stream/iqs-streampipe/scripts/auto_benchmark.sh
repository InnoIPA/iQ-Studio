#!/bin/bash

# --- Default Values ---
TEST_DURATION=300
WARMUP_TIME=180
OUTPUTPATH="./output.txt"
INPUT_PLATFORM="auto"
VENV_DIR="venv"

# --- Cleanup Function ---
cleanup() {
    echo -e "\n[INFO] Interrupt received. Cleaning up background processes..."
    jobs -p | xargs -r kill
    exit 1
}

trap cleanup SIGINT SIGTERM

# --- Help Message ---
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --test_time SECS     Total test duration (default: 300)"
    echo "  --warmup_time SECS   Warmup time before monitoring (default: 180)"
    echo "  --output PATH        Output file path (default: ./output.txt)"
    echo "  --platform TYPE      Platform: auto, nv, qcom (default: auto)"
    echo "  --help               Display this help message"
    exit 1
}

# --- Parse Arguments ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --test_time) TEST_DURATION="$2"; shift 2 ;;
        --warmup_time) WARMUP_TIME="$2"; shift 2 ;;
        --output) OUTPUTPATH="$2"; shift 2 ;;
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

# --- Environment Setup ---
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
    pip3 install -r requirement.txt
else
    source "$VENV_DIR/bin/activate"
fi

# make sure the output folder and cleanup the output folder
mkdir -p "$(dirname "$OUTPUTPATH")"
> "$OUTPUTPATH"

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

# --- Execution ---
case "$TARGET_PLATFORM" in
    "nv")
        export DISPLAY=:1
        timeout "${TEST_DURATION}" ./nvidia/streampipe_nv -c config_nv.json -b --warmup_time "${WARMUP_TIME}" 1> >(tee "$OUTPUTPATH") &
        BENCH_PID=$!
        ;;
    "qcom")
        # --- Execution ---
        echo "[INFO] Image found. Starting iqs-launcher..."
        timeout "${TEST_DURATION}" iqs-launcher --autotag iqs-streampipe --other " -c config.json -b --warmup_time ${WARMUP_TIME}" 1> >(tee "$OUTPUTPATH") &
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
    timeout "${MONITOR_DURATION}" ./venv/bin/python3 ./scripts/system_monitor.py 1> >(tee "$OUTPUTPATH")
else
    echo "[ERROR] Benchmark process failed to start or crashed during warmup." 2>&1
    exit 1
fi

echo "[SUCCESS] Benchmark completed. Results saved to $OUTPUTPATH"