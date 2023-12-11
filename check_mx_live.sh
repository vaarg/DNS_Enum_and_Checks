#!/bin/bash

# Check if a domain is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1

# Get MX records
echo "Getting MX records for $DOMAIN..."
MX_RECORDS=$(dig mx $DOMAIN +short)

# Loop through each MX record
for mx in $MX_RECORDS; do
    # Extract MX domain
    MX_DOMAIN=$(echo $mx | awk '{print $2}')

    # If MX_DOMAIN is empty, skip to the next record
    if [ -z "$MX_DOMAIN" ]; then
        continue
    fi

    echo "Looking up IPs for $MX_DOMAIN..."
    
    # Get IPs for MX domain
    IPs=$(dig +short $MX_DOMAIN)

    # Check if each IP is alive
    for ip in $IPs; do
        echo "Pinging $ip..."
        ping -c 1 $ip > /dev/null 2>&1

        # Check the exit status of ping
        if [ $? -eq 0 ]; then
            echo "$ip is alive."
        else
            echo "$ip is not responding."
        fi
    done
done
