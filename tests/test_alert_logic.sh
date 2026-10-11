#!/usr/bin/env bash

set -euo pipefail

PASS=0
FAIL=0

assert_equal() {
    local description="$1"
    local actual="$2"
    local expected="$3"

    if [[ "$actual" == "$expected" ]]; then
        echo "PASS: $description"
        ((PASS+=1))
    else
        echo "FAIL: $description (expected '$expected', got '$actual')"
        ((FAIL+=1))
    fi
}

resource_status() {
    local usage="$1"
    local threshold="$2"

    if (( usage > threshold )); then
        echo "WARNING"
    else
        echo "HEALTHY"
    fi
}

overall_status() {
    local cpu="$1"
    local memory="$2"
    local disk="$3"
    local services="$4"

    if [[ "$cpu" == "WARNING" ||
          "$memory" == "WARNING" ||
          "$disk" == "WARNING" ||
          "$services" == "WARNING" ]]; then
        echo "ATTENTION REQUIRED"
    else
        echo "HEALTHY"
    fi
}

echo "Testing resource threshold decisions..."

assert_equal "CPU below threshold" \
    "$(resource_status 79 80)" "HEALTHY"

assert_equal "CPU exactly at threshold" \
    "$(resource_status 80 80)" "HEALTHY"

assert_equal "CPU above threshold" \
    "$(resource_status 81 80)" "WARNING"

assert_equal "Memory above threshold" \
    "$(resource_status 81 80)" "WARNING"

assert_equal "Disk above threshold" \
    "$(resource_status 81 80)" "WARNING"

echo
echo "Testing overall health decisions..."

assert_equal "All resources healthy" \
    "$(overall_status HEALTHY HEALTHY HEALTHY HEALTHY)" "HEALTHY"

assert_equal "CPU warning requires attention" \
    "$(overall_status WARNING HEALTHY HEALTHY HEALTHY)" \
    "ATTENTION REQUIRED"

assert_equal "Memory warning requires attention" \
    "$(overall_status HEALTHY WARNING HEALTHY HEALTHY)" \
    "ATTENTION REQUIRED"

assert_equal "Disk warning requires attention" \
    "$(overall_status HEALTHY HEALTHY WARNING HEALTHY)" \
    "ATTENTION REQUIRED"

assert_equal "Service warning requires attention" \
    "$(overall_status HEALTHY HEALTHY HEALTHY WARNING)" \
    "ATTENTION REQUIRED"

echo
echo "Results: $PASS passed, $FAIL failed"

if (( FAIL > 0 )); then
    exit 1
fi

echo "All alert logic tests passed."
