
#!/bin/bash

#############################################
# utils.sh
#############################################

rotate_log() {

    local logfile="$1"
    local max_size=1048576

    if [ -f "$logfile" ]; then

        local size
        size=$(stat -c%s "$logfile")

        if [ "$size" -ge "$max_size" ]; then

            [ -f "${logfile}.2" ] && rm -f "${logfile}.2"
            [ -f "${logfile}.1" ] && mv "${logfile}.1" "${logfile}.2"

            mv "$logfile" "${logfile}.1"

            touch "$logfile"

            log_info "Log rotated: ${logfile}"
        fi
    fi
}


get_cpu_usage() {

    local idle

    idle=$(vmstat 1 2 | tail -1 | awk '{print $15}')

    echo $((100-idle))
}

get_memory_usage() {

    local total
    local used

    total=$(free | awk '/Mem:/ {print $2}')
    used=$(free | awk '/Mem:/ {print $3}')

    echo $((used*100/total))
}

get_disk_usage() {

    df / | awk 'NR==2 {gsub("%","",$5); print $5}'
}

get_hostname() {

    hostname
}

get_uptime() {

    uptime -p
}

get_logged_users() {

    who
}

top_memory_processes() {

    ps aux --sort=-%mem | head
}

get_os_name() {
    source /etc/os-release
    echo "$PRETTY_NAME"
}

get_kernel_version() {
    uname -r
}

get_ip_address() {
    hostname -I | awk '{print $1}'
}

get_load_average() {
    uptime | awk -F'load average:' '{print $2}'
}