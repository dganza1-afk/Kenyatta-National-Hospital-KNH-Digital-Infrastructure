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
water_audit() {
    echo ""
    echo "=== Water Usage Audit ==="
 
    WATER_LOG="active_logs/water_usage.log"
 
    if [ ! -f "$WATER_LOG" ]; then
        echo "Water usage log not found: $WATER_LOG"
        return 1
    fi
 
    # Assumes CSV columns: Timestamp,Device_ID,Value,Status
    # $2 = Device_ID, $3 = Value (liters).
    # Filter to only ICU_WATER_RESERVE readings, sum and count them, then
    # compute the average in the awk END block.
    awk -F',' '
        $2 == "ICU_WATER_RESERVE" {
            sum += $3
            count++
        }
        END {
            if (count > 0) {
                avg = sum / count
                printf "%-25s %10d\n",    "Total Readings:",   count
                printf "%-25s %10.2f L\n", "Total Water Used:", sum
                printf "%-25s %10.2f L\n", "Average Usage:",    avg
            } else {
                print "No ICU_WATER_RESERVE readings found."
            }
        }
    ' "$WATER_LOG"
 
    echo "=========================="
}
 
