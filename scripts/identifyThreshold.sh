#!/bin/bash
DIRECTORY="/Users/andrewhsu/Projects/McNair/data/gxdrnaseq"
OUTPUT="/Users/andrewhsu/Projects/McNair/data/identifyThreshold.txt"

> "$OUTPUT"
echo "Reading Avg QN TPM and TPM Level Column"
find "$DIRECTORY" -type f -print0 | while IFS= read -r -d '' file; do
    awk -F'|' 'NR > 1 {print $(NF - 1) "," $NF}' "$file" >> "$OUTPUT"
    echo "Completed $(basename $file)"
done
echo "Done"