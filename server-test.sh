#!/bin/bash
#
# server-stats.sh - A simple script to analyze basic server performance
# Works on most Linux distributions
#

echo "=============================================="
echo "     Server Performance Stats - $(hostname)"
echo "     Date: $(date)"
echo "=============================================="
echo

# -------------------------------
# CPU USAGE
# -------------------------------
echo "🔹 Total CPU Usage:"
# mpstat gives detailed stats, but fallback to top if not installed
if command -v mpstat >/dev/null 2>&1; then
    cpu_idle=$(mpstat 1 1 | awk '/Average/ {print 100 - $NF}')
    echo "CPU Usage: ${cpu_idle}%"
else
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    echo "CPU Usage: ${cpu_idle}%"
fi
echo

# -------------------------------
# MEMORY USAGE
# -------------------------------
echo "🔹 Memory Usage:"
free -h | awk '/Mem:/ {
    total=$2; used=$3; free=$4;
    printf "Total: %s | Used: %s | Free: %s | Usage: %.2f%%\n", total, used, free, (used/$2)*100
}'
echo

# -------------------------------
# DISK USAGE
# -------------------------------
echo "🔹 Disk Usage (All Mounts):"
df -h --total | awk '/total/ {
    printf "Total: %s | Used: %s | Free: %s | Usage: %s\n", $2, $3, $4, $5
}'
echo

# -------------------------------
# TOP 5 PROCESSES - CPU
# -------------------------------
echo "🔹 Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
echo

# -------------------------------
# TOP 5 PROCESSES - MEMORY
# -------------------------------
echo "🔹 Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6
echo

echo "✅ Stats collection complete."
