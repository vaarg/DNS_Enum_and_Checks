#!/bin/bash

# Check if the file name is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

filename=$1

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "File not found: $filename"
    exit 1
fi

# Loop through each line in the file
while IFS= read -r url
do
    echo "Scanning $url with wafw00f..."
    wafw00f $url
    echo "---------------------------------"
done < "$filename"
