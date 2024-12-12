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
    local default_sleep_seconds=$2
    local first_loop_sleep=$3

    # Re-enable debug mode if it was set in the parent script
    [[ ${TRACE:-false} == "true" ]] && set -x

    logfile="test-multiple-${setup_type}-$(date +%Y%m%d-%H%M%S).log"
    echo "Starting test run at $(date -u)" >"$logfile"

    MAX_TESTS=100
    SLEEP_TIME_SECONDS=${SLEEP_TIME_SECONDS:-$default_sleep_seconds}
    echo "Using sleep time of ${SLEEP_TIME_SECONDS} seconds" | tee -a "$logfile"

    for i in $(seq 1 $MAX_TESTS); do
        echo -e "\n=== Iteration $i starting at $(date -u) ===" | tee -a "$logfile"
        echo "Grants before iteration $i:" | tee -a "$logfile"
        bash ${TRACE:+-x} check-kms-grants.sh >>"$logfile" 2>&1

        # First teardown
        if ! just teardown; then
            echo "Failed at iteration $i during teardown at $(date -u)" | tee -a "$logfile"
            echo "Final grant state:" | tee -a "$logfile"
            bash ${TRACE:+-x} check-kms-grants.sh >>"$logfile" 2>&1
            echo "Running debug:" | tee -a "$logfile"
            just debug >>"$logfile" 2>&1
            exit 1
        fi

        # Sleep between iterations
        if [ "$SLEEP_TIME_SECONDS" -gt 0 ] && { [ "$i" -ne 1 ] || [ "$first_loop_sleep" = "yes" ]; }; then
            local s="${SLEEP_TIME_SECONDS} seconds"
            local m=$(units --terse "$s" minutes)
            echo "Sleeping for ${m} minutes... in round ${i}" | tee -a "$logfile"
            sleep "${SLEEP_TIME_SECONDS}s"
        fi

        # Finally setup
        if ! just setup-${setup_type}; then
            echo "Failed at iteration $i during setup at $(date -u)" | tee -a "$logfile"
            echo "Final grant state:" | tee -a "$logfile"
            bash ${TRACE:+-x} check-kms-grants.sh >>"$logfile" 2>&1
            echo "Running debug:" | tee -a "$logfile"
            just debug >>"$logfile" 2>&1
            exit 1
        fi

        curl -d "Iteration $i succeeded" ntfy.sh/mtmonacelli-itsfergus
        echo "Iteration $i succeeded" | tee -a "$logfile"
        echo "Grants after iteration $i:" | tee -a "$logfile"
        bash ${TRACE:+-x} check-kms-grants.sh >>"$logfile" 2>&1
    done

    echo "All iterations completed successfully at $(date -u)" | tee -a "$logfile"
}
