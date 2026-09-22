#!/bin/bash

TIMESTAMP=$(date +"%Y%m%d_%H%M")
echo "Timestamp generated: $TIMESTAMP"

rotate_logs() {
    echo " M4: Rotating logs (timestamp: $TIMESTAMP)"
 
    mkdir -p active_logs archived_logs
 
    for logfile in heart_rate temperature water_usage; do
        SRC="active_logs/${logfile}.log"
        DEST="archived_logs/${logfile}_${TIMESTAMP}.log"
 
        if [ -f "$SRC" ]; then
            echo "Archiving $SRC -> $DEST"
            mv "$SRC" "$DEST"
        else
            echo "Warning: $SRC not found. Nothing to archive for $logfile."
        fi
 
        # Recreate the empty active log so the Python engine can keep recording.
        echo "Recreating empty $SRC"
        touch "$SRC"
    done
 
    echo " Log rotation complete."
