process_vitals() {

    echo " M5: Scanning vitals for CRITICAL readings"
 
  mkdir -p reports
    # Fresh report each run.
    echo "Timestamp,Device_ID,Value" > reports/critical_alerts.txt
 
    if [ -f "active_logs/heart_rate.log" ]; then
        grep "CRITICAL" active_logs/heart_rate.log \
            | awk -F',' '{print $1","$2","$3}' >> reports/critical_alerts.txt
        echo "Heart rate log scanned."
    else
        echo "Warning: active_logs/heart_rate.log not found. Skipping."
    fi
 
    if [ -f "active_logs/temperature.log" ]; then
        grep "CRITICAL" active_logs/temperature.log \
            | awk -F',' '{print $1","$2","$3}' >> reports/critical_alerts.txt
        echo "Temperature log scanned."
    else
        echo "Warning: active_logs/temperature.log not found. Skipping."
    fi
 
    alert_count=$(( $(wc -l < reports/critical_alerts.txt) - 1 ))
    echo "Done. $alert_count critical alert(s) written to reports/critical_alerts.txt"
    echo ""
}
