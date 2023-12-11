#!/bin/bash

# Note: If hosted by AWS or whatnot this will fail, but it's fine.

# Check if a hostname is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

HOSTNAME=$1

# Forward DNS lookup (Hostname to IP)
IP=$(dig +short $HOSTNAME | head -n 1)

if [ -z "$IP" ]; then
    echo "Forward DNS lookup failed for $HOSTNAME"
    exit 1
fi

echo "Forward DNS: $HOSTNAME -> $IP"

# Reverse DNS lookup (IP to Hostname)
REVERSE_HOSTNAME=$(dig +short -x $IP | head -n 1)

if [ -z "$REVERSE_HOSTNAME" ]; then
    echo "Reverse DNS lookup failed for $IP"
    exit 1
fi

echo "Reverse DNS: $IP -> $REVERSE_HOSTNAME"

# Check if the reverse DNS matches the original hostname
if [ "$REVERSE_HOSTNAME" = "$HOSTNAME." ]; then
    echo "DNS consistency check passed: $HOSTNAME matches $REVERSE_HOSTNAME"
else
    echo "DNS consistency check failed: $HOSTNAME does not match $REVERSE_HOSTNAME"
fi
