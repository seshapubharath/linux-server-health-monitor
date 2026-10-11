#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load logger functions required by utils.sh.
source "$ROOT_DIR/scripts/logger.sh"
source "$ROOT_DIR/scripts/utils.sh"

PASS=0
FAIL=0

assert_non_empty() {
    local name="$1"
    local value="$2"

    if [[ -n "$value" ]]; then
        echo "PASS: $name"
        ((PASS+=1))
    else
        echo "FAIL: $name returned empty output"
        ((FAIL+=1))
    fi
}

assert_percentage() {
    local name="$1"
    local value="$2"

    if [[ "$value" =~ ^[0-9]+$ ]] &&
       (( value >= 0 && value <= 100 )); then
        echo "PASS: $name ($value%)"
        ((PASS+=1))
    else
        echo "FAIL: $name returned invalid percentage: '$value'"
        ((FAIL+=1))
    fi
}

echo "Running Linux Server Health Monitor functional tests..."

# CPU usage
cpu="$(get_cpu_usage)"
assert_percentage "CPU usage" "$cpu"

# Memory usage
memory="$(get_memory_usage)"
assert_percentage "Memory usage" "$memory"

# Disk usage
disk="$(get_disk_usage)"
assert_percentage "Disk usage" "$disk"

# Hostname
hostname_value="$(get_hostname)"
assert_non_empty "Hostname" "$hostname_value"

# Uptime
uptime_value="$(get_uptime)"
assert_non_empty "Uptime" "$uptime_value"

# Logged-in users command should execute successfully.
if get_logged_users >/dev/null; then
    echo "PASS: Logged-in users command"
    ((PASS+=1))
else
    echo "FAIL: Logged-in users command"
    ((FAIL+=1))
fi

# Process listing should produce output.
processes="$(top_memory_processes)"
assert_non_empty "Top memory processes" "$processes"

# OS name
os_name="$(get_os_name)"
assert_non_empty "Operating system name" "$os_name"

# Kernel version
kernel="$(get_kernel_version)"
assert_non_empty "Kernel version" "$kernel"

# IP address
ip_address="$(get_ip_address)"
assert_non_empty "IP address" "$ip_address"

# Load average
load_average="$(get_load_average)"
assert_non_empty "Load average" "$load_average"

# Test log rotation with a temporary file.
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

test_log="$tmp_dir/test.log"

# Create a file exactly at the rotation threshold.
head -c 1048576 /dev/zero > "$test_log"

rotate_log "$test_log"

if [[ -f "${test_log}.1" && -f "$test_log" && ! -s "$test_log" ]]; then
    echo "PASS: Log rotation"
    ((PASS+=1))
else
    echo "FAIL: Log rotation"
    ((FAIL+=1))
fi

echo
echo "Results: $PASS passed, $FAIL failed"

if (( FAIL > 0 )); then
    exit 1
fi

echo "All functional tests passed."
