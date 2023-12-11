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

    # Check if each IP is alive
    for ip in $IPs; do
        echo "Pinging $ip..."
        if ping -c 1 $ip &> /dev/null; then
            echo "$ip is alive."
        else
            echo "$ip is not responding."
        fi
    done
done
