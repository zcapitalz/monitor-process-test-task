#!/bin/bash

PROCESS_NAME="test"
MONITOR_URL="https://test.com/monitoring/test/api"
TMP_DIR="/var/tmp/monitor_test"
LOG_FILES_DIR="/var/log/monitor_test"

LOG_FILE="$LOG_FILES_DIR/monitoring.log"
LAST_PID_FILE="$TMP_DIR/monitor_test_last_pid"
CURL_STDERR_FILE="$TMP_DIR/curl_stderr"

mkdir -p "$TMP_DIR" "$LOG_FILES_DIR"

PROCESS_PID=$(pgrep -x "$PROCESS_NAME")

if [ -n "$PROCESS_PID" ]; then
    LAST_PID=$(cat "$LAST_PID_FILE" 2>/dev/null || echo "")

    if [ "$LAST_PID" != "$PROCESS_PID" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Process $PROCESS_NAME(PID: $PROCESS_PID) restarted" >> "$LOG_FILE"
        echo "$PROCESS_PID" > "$LAST_PID_FILE"
    fi

    RESPONSE_CODE=$(curl \
        --silent \
        --show-error \
        --output /dev/null \
        --write-out "%{http_code}" \
        --connect-timeout 5 \
        "$MONITOR_URL" \
        2>"$CURL_STDERR_FILE")

    if [ "$RESPONSE_CODE" -ne 200 ]; then
        CURL_STDERR=$(cat "$CURL_STDERR_FILE")
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Monitoring service unavailable (HTTP code: $RESPONSE_CODE, curl response: $CURL_STDERR)" >> "$LOG_FILE"
    fi
fi