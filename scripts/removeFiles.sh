#!/bin/bash
DIRECTORY="/Users/andrewhsu/Projects/McNair/data/gxdrnaseq"
UNIQUE_TISSUES="/Users/andrewhsu/Projects/McNair/uniqueTissues.txt"
HUMAN_TISSUES="/Users/andrewhsu/Projects/McNair/data/humanData.csv"

> "$UNIQUE_TISSUES"
echo "Starting file processing in $DIRECTORY."
echo "Reading human tissues."

awk -F',' 'NR > 1 {print tolower($NF)}' "$HUMAN_TISSUES" | sort -u >> "$UNIQUE_TISSUES"
echo "Processing gxdrnaseq files."
find "$DIRECTORY" -type f -print0 | while IFS= read -r -d '' file; do
    value=$(awk -F'|' 'NR > 1 {print $6; exit}' "$file")
    if ! grep -F -x -q "$value" "$UNIQUE_TISSUES"; then
        echo "Deleting $file"
        rm "$file"
    fi
done
rm "$UNIQUE_TISSUES"
echo "Done."
