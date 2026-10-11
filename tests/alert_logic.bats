#!/usr/bin/env bats

# Tests for the resource threshold rules used by the monitor.

setup() {
    resource_status() {
        local usage="$1"
        local threshold="$2"

        if (( usage > threshold )); then
            echo "WARNING"
        else
            echo "HEALTHY"
        fi
    }
}

@test "usage below threshold is healthy" {
    run resource_status 79 80
    [ "$status" -eq 0 ]
    [ "$output" = "HEALTHY" ]
}

@test "usage exactly at threshold is healthy" {
    run resource_status 80 80
    [ "$status" -eq 0 ]
    [ "$output" = "HEALTHY" ]
}

@test "usage above threshold triggers warning" {
    run resource_status 81 80
    [ "$status" -eq 0 ]
    [ "$output" = "WARNING" ]
}
