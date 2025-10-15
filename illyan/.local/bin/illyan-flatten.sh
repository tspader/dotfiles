#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    echo "This will move all files from subdirectories to the parent directory"
    exit 1
fi

target_dir="${1%/}"

if [ ! -d "$target_dir" ]; then
    echo "Error: Directory '$target_dir' does not exist"
    exit 1
fi

# Find all files in subdirectories and move them to the parent directory
find "$target_dir" -mindepth 2 -type f | while read -r file; do
    # Get just the filename without path
    filename=$(basename "$file")
    parent_dir=$(dirname "$(dirname "$file")")

    # Check if a file with this name already exists in the parent directory
    if [ -e "$parent_dir/$filename" ]; then
        echo "Warning: '$filename' already exists in $parent_dir, skipping"
    else
        mv "$file" "$parent_dir/"
        echo "Moved: $file -> $parent_dir/$filename"
    fi
done

# Remove empty subdirectories
find "$target_dir" -mindepth 1 -type d -empty -delete

echo "Done flattening subdirectories in $target_dir"
