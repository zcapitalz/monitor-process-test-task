MONITOR_SCRIPT_TARGET_PATH=/usr/local/bin/monitor_test.sh
cp ./monitor_test.sh "$MONITOR_SCRIPT_TARGET_PATH"
cp ./monitor_test.service /etc/systemd/system/monitor_test.service
cp ./monitor_test.timer /etc/systemd/system/monitor_test.timer

chmod +x "$MONITOR_SCRIPT_TARGET_PATH"
systemctl daemon-reload
systemctl enable monitor_test.timer