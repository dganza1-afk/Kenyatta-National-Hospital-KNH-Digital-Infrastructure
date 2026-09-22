
secure_data() {
    chmod 700 active_logs
    echo "New permissions for active_logs:"
    ls -ld active_logs
}

secure_data

