#!/bin/bash

# This discovers most common files using Metagoofil, downloads the list of files, downloads the files, performs exiftool on all of them and then saves the output.
# Downloads 20 files by default.

# Prompt user to enter a domain
echo "Please enter the DOMAIN: "
read DOMAIN

# Run metagoofil with the entered domain & download files
metagoofil -d "$DOMAIN" -t pdf,doc,xls,ppt,docx,xlsx,pptx -n 20 -o Downloaded_Files -f "metagoofil_${DOMAIN}.html"

# Run Exiftool on every downloaded file and saves to file.
for file in ./Downloaded_Files/*; do 
    exiftool "$file" | tee -a Metadata_All_Documents.txt
    echo -e "\e[32m-----------------------------------------------------\e[0m" | tee -a Metadata_All_Documents.txt
done

echo -e "\e[32mOutput saved to Metadata_All_Documents.txt\e[0m"
