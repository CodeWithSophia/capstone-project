#!/bin/bash

# Define directories and files
datahub_dir="datahub"
output_dir="db_folder"
output_file="${output_dir}/combined.csv"
log_file="processed_files.log"

# Ensure necessary files and directories exist
mkdir -p "$output_dir"
touch "$log_file"

# Process new files
for file in "$datahub_dir"/*.csv; do
    if ! grep -q "$(basename "$file")" "$log_file"; then
        echo "Processing new file: $file"
        
        if [ ! -f "$output_file" ]; then
            # Create the combined file with the header from the first file
            head -n 1 "$file" > "$output_file"
        fi
        
        # Append the data (excluding header) from the new file
        tail -n +2 "$file" >> "$output_file"
        
        # Log the processed file
        echo "$(basename "$file")" >> "$log_file"
    else
        echo "File $file already processed. Skipping."
    fi
done

# Calculate rows and columns in the combined file
row_count=$(wc -l < "$output_file")
column_count=$(head -n 1 "$output_file" | awk -F',' '{print NF}')

echo "CSV Integration Complete:"
echo "Rows: $((row_count - 1)) (excluding the header)"
echo "Columns: $column_count"
