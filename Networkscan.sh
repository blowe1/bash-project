#!/bin/bash

function display_usage {

    echo "Usage for Networkscan.sh"
    echo "Options:"
    echo " -h       Display this help message"
    echo "This script performs a basic network scan on the provided IP and user selects TCP or UDP"
    exit 0
} 

if ["$1" == "-h" ]; then
    display_usage
    exit 1
fi

read -p "Enter the IP address you would like to scan: "  ip_addr

regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

if [!ip_addr =~ $regex]; then
    echo "Error: Invalid IP address"
    exit 1
fi


echo "scanning network $network for devices"


nmap -sV --allports -T4 $network -oN ~/Documents/network_scan_results.txt


echo "Scan finished, results saved in ~/Documents/network_scan_results.txt