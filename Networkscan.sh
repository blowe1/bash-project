#!/bin/bash

#modified version for Scripting Languages

# help message display
function display_help() {
    echo "Usage: $0 [-h] -i IP_ADDRESS [-p PORT_RANGE] [-o OUTPUT_FILE]"
    echo "Options:"
    echo "  -h                 Display this help message."
    echo "  -i IP_ADDRESS      Specify the IP address or network to scan (e.g., 192.168.0.0/24)."
    echo "  -p PORT_RANGE      Specify the range of ports to scan (e.g., 20-80). Default: all ports."
    echo "  -o OUTPUT_FILE     Specify the output file to save the scan results. Default: ~/Documents/network_scan_results.txt."
    exit 1
}
#Ip validation regex
function validate_ip() {
    local ip=$1
    # Validate for both IP address and network format (e.g., 192.168.0.0/24)
    if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}(/([0-9]|[1-2][0-9]|3[0-2]))?$ ]]; then
        # Check each octet (for non-network format) is between 0 and 255
        for octet in $(echo $ip | grep -oE '([0-9]{1,3})' | head -n 4); do
            if ((octet < 0 || octet > 255)); then
                echo "Invalid IP address or network: $ip"
                exit 1
            fi
        done
        echo "Valid IP address or network: $ip"
    else
        echo "Invalid IP address or network format: $ip"
        exit 1
    fi
}
#port range and name of output file
port_range=""
output_file=~/Documents/network_scan_results.txt

#commands
while getopts "h:i:p:o:" opt; do
    case ${opt} in
        h)
            display_help
            ;;
        i)
            ip_address=$OPTARG
            ;;
        p)
            port_range=$OPTARG
            ;;
        o)
            output_file=$OPTARG
            ;;
        *)
            display_help
            ;;
    esac
done
#ip verification
if [ -z "$ip_address" ]; then
    echo "Error: IP address or network is required."
    display_help
fi
#network scan
if [ -z "$port_range" ]; then
    echo "No port range provided. Scanning all ports on $ip_address..."
    nmap -sV --allports -T4 $ip_address -oN $output_file
else
    echo "Scanning network $ip_address for devices on ports $port_range..."
    nmap -sV -p $port_range -T4 $ip_address -oN $output_file
fi

echo "Scan finished, results saved in $output_file"