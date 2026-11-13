#!/usr/bin/env python3
import argparse
import subprocess
import time
import os
import threading
import queue
import shutil
import signal
import sys

exit_event = threading.Event()

def get_system_mem_usage():
    try:
        meminfo = {}
        with open("/proc/meminfo", "r") as f:
            for line in f:
                key, val = line.split(":", 1)
                meminfo[key] = int(val.strip().split()[0])  # kB

        total = meminfo.get("MemTotal")
        available = meminfo.get("MemAvailable")
        if total and available:
            return (total - available) / total * 100.0
    except Exception:
        pass
    return None

def get_cpu_usage(interval=0.1):
    def read_cpu():
        with open("/proc/stat", "r") as f:
            line = f.readline()
        parts = line.split()
        if parts[0] != "cpu":
            return None
        return list(map(int, parts[1:]))

    cpu1 = read_cpu()
    time.sleep(interval)
    cpu2 = read_cpu()
    
    if not cpu1 or not cpu2:
        return None

    idle1 = cpu1[3] + cpu1[4]  # idle + iowait
    idle2 = cpu2[3] + cpu2[4]

    total1 = sum(cpu1)
    total2 = sum(cpu2)

    total_diff = total2 - total1
    idle_diff = idle2 - idle1

    if total_diff == 0:
        return None

    usage = (total_diff - idle_diff) / total_diff * 100.0
    return usage

def signal_handler(signum, frame):
    if signum == 2:
        sign = "SIGINT"
    elif signum == 15:
        sign = "SIGTERM"
    print(f"Received signal {sign}, exiting gracefully...")
    exit_event.set()

def monitor_loop(profile_time):

    # cpu_history = []
    # mem_history = []
    cpu_total = []
    mem_total = []

    while not exit_event.is_set():
        cpu_results = get_cpu_usage()
        mem_results = get_system_mem_usage()

        if cpu_results is not None:
            # cpu_history.append(cpu_results)
            cpu_total.append(cpu_results)
        if mem_results is not None:
            # mem_history.append(mem_results)
            mem_total.append(mem_results)

        # if len(cpu_history) * 0.5 >= profile_time:
        #     avg_cpu = sum(cpu_history) / len(cpu_history)
        #     avg_mem = sum(mem_history) / len(mem_history)

        #     cpu_str = f"CPU={avg_cpu:.1f}%"
        #     mem_str = f"MEM={avg_mem:.1f}%"
        #     print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {cpu_str} | {mem_str}")

        #     cpu_history.clear()
        #     mem_history.clear()

        # time.sleep(0.5)
    
    if cpu_total and mem_total:
        print("Final Average CPU Usage:", f"{sum(cpu_total)/len(cpu_total):.1f}%")
        print("Final Average MEM Usage:", f"{sum(mem_total)/len(mem_total):.1f}%")

def main():
    parser = argparse.ArgumentParser(description="System monitor for CPU, MEM")
    parser.add_argument("-p", "--profile-time", type=int, default=5, help="Profile time for qprof averaging in seconds, default=5")
    args = parser.parse_args()

    signal.signal(signal.SIGTERM, signal_handler)
    signal.signal(signal.SIGINT, signal_handler)

    monitor_loop(profile_time=args.profile_time)

if __name__ == "__main__":
    main()
