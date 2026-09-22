#!/bin/bash
initialize_system() {
    if [ ! -d "active_logs" ]; then
        echo "Creating active_logs directory..."
        mkdir active_logs
    fi

    if [ ! -d "archived_logs" ]; then
        echo "Creating archived_logs directory..."
        mkdir archived_logs
    fi

    if [ ! -d "reports" ]; then
        echo "Creating reports directory..."
        mkdir reports
    fi

    echo "System initialization complete."
}
# ============================================================
# MEMBER 3: THE ORCHESTRATOR
# Execute functions in the required order
# ============================================================

echo "=========================================="
echo "KNH DIGITAL INFRASTRUCTURE"
echo "Hospital Administration System"
echo "=========================================="
echo

# Step 1: Initialize the system
initialize_system

# Step 2: Secure the data
secure_data

# Step 3: Confirm completion
echo "=========================================="
echo "System Environment Secured"
echo "Date: $(date)"
echo "=========================================="
