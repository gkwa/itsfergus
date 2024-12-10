#!/usr/bin/env bash
set -e

format_sleep_time() {
    local seconds=$1
    if [ "$seconds" -ge 3600 ]; then
        local hours=$(echo "scale=2; $seconds/3600" | bc)
        echo "${hours}h"
    elif [ "$seconds" -ge 60 ]; then
        local minutes=$(echo "scale=2; $seconds/60" | bc)
        echo "${minutes}m"
    else
        echo "${seconds}s"
    fi
}

run_test() {
    local setup_type=$1
    local default_sleep=$2

    logfile="test-multiple-${setup_type}-$(date +%Y%m%d-%H%M%S).log"
    echo "Starting test run at $(date -u)" >"$logfile"

    SLEEP_TIME=${SLEEP_TIME:-$default_sleep}
    echo "Using sleep time of ${SLEEP_TIME} seconds" | tee -a "$logfile"

    for i in {1..100}; do
        echo -e "\n=== Iteration $i starting at $(date -u) ===" | tee -a "$logfile"
        echo "Grants before iteration $i:" | tee -a "$logfile"
        ./check-kms-grants.sh >>"$logfile" 2>&1

        # First teardown
        if ! just teardown; then
            echo "Failed at iteration $i during teardown at $(date -u)" | tee -a "$logfile"
            echo "Final grant state:" | tee -a "$logfile"
            ./check-kms-grants.sh >>"$logfile" 2>&1
            echo "Running debug:" | tee -a "$logfile"
            just debug >>"$logfile" 2>&1
            exit 1
        fi

        # Then sleep
        if [ "$SLEEP_TIME" -gt 0 ]; then
            formatted_time=$(format_sleep_time "$SLEEP_TIME")
            echo "Sleeping for ${formatted_time}..." | tee -a "$logfile"
            sleep "$SLEEP_TIME"
        fi

        # Finally setup
        if ! just setup-${setup_type}; then
            echo "Failed at iteration $i during setup at $(date -u)" | tee -a "$logfile"
            echo "Final grant state:" | tee -a "$logfile"
            ./check-kms-grants.sh >>"$logfile" 2>&1
            echo "Running debug:" | tee -a "$logfile"
            just debug >>"$logfile" 2>&1
            exit 1
        fi

        curl -d "Iteration $i succeeded" ntfy.sh/mtmonacelli-itsfergus
        echo "Iteration $i succeeded" | tee -a "$logfile"
        echo "Grants after iteration $i:" | tee -a "$logfile"
        ./check-kms-grants.sh >>"$logfile" 2>&1
    done

    echo "All iterations completed successfully at $(date -u)" | tee -a "$logfile"
}
