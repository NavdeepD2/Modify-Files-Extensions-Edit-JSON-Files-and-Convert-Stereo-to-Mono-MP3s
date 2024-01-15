#!/bin/bash
# Written by Navdeep Singh (navdeep.d2@gmail.com)

# ANSI escape codes for colors and styles
GREEN='\033[1;32m'
BOLD='\033[1m'
RESET='\033[0m'
# Phase 1 - Replacing Extensions

scriptpath=$(pwd)
# Audio
for file in audio/*.MP3; do
    mv "$file" "${file%.MP3}.mp3" >/dev/null 2>&1
done
echo -e "Change .MP3 to .mp3 - ${GREEN}${BOLD}DONE${RESET}"
# Images
# Define the directory path
images_directory="images"

# Check if the directory exists
if [ -d "$images_directory" ]; then
    # Change to the images directory
    cd "$images_directory" || exit 1

    # Loop through files in the directory
    for file in *; do
        if [ -f "$file" ]; then
            # Get the file extension in lowercase
            extension=$(echo "$file" | awk -F. '{print tolower($NF)}')

            # Rename the file based on the extension
            case "$extension" in
                jpg|jpeg)
                    mv "$file" "${file%.*}.jpg" >/dev/null 2>&1
                    #echo "Renamed $file to ${file%.*}.jpg"
                    ;;
                png)
                    mv "$file" "${file%.*}.png" >/dev/null 2>&1
                    #echo "Renamed $file to ${file%.*}.png"
                    ;;
            esac
        fi
    done

    echo -e "Change Images extension to .jpg / .png - ${GREEN}${BOLD}DONE${RESET}"
else
    echo "Images directory not found."
fi
cd "$scriptpath"

# Conf
for file in *.conf; do
    mv "$file" "${file%.conf}.json" >/dev/null 2>&1
done

echo -e "Change .conf to .json - ${GREEN}${BOLD}DONE${RESET}"

# Phase 2 - Modifying Json files for extensions

for file in *.json; do
    sed -i'' -e 's/\.JPG/.jpg/g' -e 's/\.JPEG/.jpg/g' -e 's/\.jpeg/.jpg/g' -e 's/\.PNG/.png/g' "$file"
done

echo -e "Replace Images extensions in .json files - ${GREEN}${BOLD}DONE${RESET}"

# Phase 3 - Remove splash_screen code from Json files

for file in menu*.json; do
    sed -i'' '/"splash_screen": {/,/},/d' "$file"
done

echo -e "Remove splash_screen code from menu*.json files - ${GREEN}${BOLD}DONE${RESET}"

# Phase 4 - Create image_list.js

cd "$scriptpath"
# Define the directory path
images_directory="./images"

# Create the image_list.js file
echo "const image_list = {" > image_list.js

# Iterate over each file in the images directory
for file_path in "$images_directory"/*; do
    # Extract the file name
    file_name=$(basename "$file_path")
    # Append the file entry to image_list.js
    echo "\"$file_name\": require('./$file_name')," >> image_list.js
done

# Complete the image_list.js file
echo "}" >> image_list.js
echo "export default image_list" >> image_list.js


cd "$scriptpath"
echo -e "Create image_list.js - ${GREEN}${BOLD}DONE${RESET}"

# Phase 5 - Create file_list.js

echo "const file_list = {" > file_list.js
for file in *.json; do
    filename="${file%.*}"
    echo "\"$filename\": require('./$file')," >> file_list.js
done
echo "};" >> file_list.js
echo "export default file_list" >> file_list.js

echo -e "Create file_list.js - ${GREEN}${BOLD}DONE${RESET}"
# Phase 6 - Stereo to Mono

# Create the output directory if it doesn't exist
cd "$scriptpath"
mkdir -p audio/output
cd audio
# Loop through all .mp3 files in the audio directory

echo -e "Converting .mp3 files from Stereo to Mono ....."
for file in *.mp3; do
    # Get the filename without the directory path
    filename=$(basename -- "$file")

    # Run ffmpeg command on each file
    ffmpeg -i "$file" -ac 1 "output/$filename" >/dev/null 2>&1
done
echo -e "Converting .mp3 files from Stereo to Mono - ${GREEN}${BOLD}DONE${RESET}"
