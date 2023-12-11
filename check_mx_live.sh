#!/bin/bash

# Check if a domain is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1

# Get MX records
echo "Getting MX records for $DOMAIN..."
MX_RECORDS=$(dig mx $DOMAIN +short | awk '{print $2}')

# Loop through each MX record
for MX_DOMAIN in $MX_RECORDS; do
    echo "Looking up IPs for $MX_DOMAIN..."

    # Get IPs for MX domain
    IPs=$(dig +short $MX_DOMAIN)

    # Check if each IP is alive using nmap
    for ip in $IPs; do
        echo "Checking $ip with nmap..."
        if nmap -sn $ip | grep -q "Host is up"; then
            echo "$ip is alive."
        else
            echo "$ip is not responding or blocked."
        fi
    done
done
