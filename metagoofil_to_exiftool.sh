#!/bin/bash

# This discovers most common files using Metagoofil, downloads the list of files, downloads the files, performs exiftool on all of them and then saves the output.

# Prompt user to enter a domain
echo "Please enter the DOMAIN:"
read DOMAIN

# Run metagoofil with the entered domain
metagoofil -d "$DOMAIN" -t pdf,doc,xls,ppt,docx,xlsx,pptx -f "metagoofil_${DOMAIN}.html"

# Wget all found files (yes I know metagoofil can do this off the bat, this is just so I can mod the script in case there are too many found files)
mkdir -p Downloaded_Files 
while read line; do wget -P Downloaded_Files "$line"; done < metagoofil_${DOMAIN}.html

# Run Exiftool on every downloaded file and saves to file.
for file in ./Downloaded_Files/*; do exiftool "$file"; echo -e "\e[32m-----------------------------------------------------\e[0m"; done | tee Metadata_All_Documents.txt

echo -e "\e[32mOutput saved to Metadata_All_Documents.txt\e[0m"
