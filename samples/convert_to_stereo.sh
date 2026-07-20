#!/bin/bash

# Convert all mono audio files in the current directory to stereo
# Skips files that are already stereo

echo "Starting audio conversion to stereo..."

# Counter for processed files
converted=0
skipped=0

# Loop through common audio file extensions
for file in *.{mp3,wav,flac,m4a,ogg,aiff,aif,opus,wma}; do
    # Skip if no files match the pattern
    [ -e "$file" ] || continue

    # Get number of channels using ffprobe
    channels=$(ffprobe -v error -select_streams a:0 -show_entries stream=channels -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null)

    # Skip if ffprobe failed
    if [ -z "$channels" ]; then
        continue
    fi

    # Check if mono (1 channel)
    if [ "$channels" -eq 1 ]; then
        echo "Converting: $file (mono -> stereo)"

        # Convert to stereo using a temporary file
        temp_file="${file}.temp.wav"

        if ffmpeg -i "$file" -ac 2 -y "$temp_file" 2>/dev/null; then
            # Replace original with converted file
            mv "$temp_file" "$file"
            ((converted++))
            echo "  ✓ Converted: $file"
        else
            echo "  ✗ Failed to convert: $file"
            # Clean up temp file if it exists
            [ -e "$temp_file" ] && rm "$temp_file"
        fi
    else
        echo "Skipping: $file (already has $channels channels)"
        ((skipped++))
    fi
done

echo ""
echo "Conversion complete!"
echo "Converted: $converted files"
echo "Skipped: $skipped files"
