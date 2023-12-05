#!/bin/bash

# Use for plaintext lists of IP addresses and IP CIDR ranges.

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_filename> <output_filename>"
    exit 1
fi

INPUT_FILE=$1
OUTPUT_FILE=$2

reverse_dns() {
    local ip=$1
    echo "Reverse DNS for $ip:" >> "$OUTPUT_FILE"
    dig -x "$ip" +short >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

> "$OUTPUT_FILE"

while IFS= read -r line; do
    if [[ $line =~ "/" ]]; then
        for ip in $(nmap -sL -n "$line" | awk '/Nmap scan report/{print $NF}' | tr -d '()'); do
            reverse_dns "$ip"
        done
    else
        reverse_dns "$line"
    fi
done < "$INPUT_FILE"
