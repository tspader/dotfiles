#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Parse arguments
DRY_RUN=0
if [ "$1" = "--dry-run" ] || [ "$1" = "-n" ]; then
    DRY_RUN=1
    shift
fi

if [ $# -ne 2 ]; then
    echo "Usage: $0 [--dry-run|-n] <source_dir> <dest_dir>"
    exit 1
fi

src="${1%/}"
dst="${2%/}"

if [ ! -d "$src" ]; then
    echo "Error: Source directory '$src' does not exist"
    exit 1
fi

# Create directory structure and hardlink files
find "$src" -type d | while read -r dir; do
    # Get relative path from source root
    relpath="${dir#$src}"
    relpath="${relpath#/}"  # Remove leading slash if present

    # Create corresponding directory in destination
    if [ -z "$relpath" ]; then
        target="$dst"
    else
        target="$dst/$relpath"
    fi
    
    if [ $DRY_RUN -eq 1 ]; then
        echo -e "${BLUE}[DIR]${NC} Would create: $target"
    else
        mkdir -p "$target"
    fi
done

# Hardlink all files
find "$src" -type f | while read -r file; do
    # Get relative path from source root
    relpath="${file#$src}"
    relpath="${relpath#/}"  # Remove leading slash if present

    # Create hardlink in destination
    target="$dst/$relpath"
    
    if [ $DRY_RUN -eq 1 ]; then
        echo -e "${GREEN}[FILE]${NC} Would link: $file -> $target"
    else
        ln "$file" "$target" 2>/dev/null || echo -e "${YELLOW}Warning:${NC} Could not hardlink $file"
    fi
done

if [ $DRY_RUN -eq 1 ]; then
    echo -e "${YELLOW}Dry run complete.${NC} No changes were made."
else
    echo -e "${GREEN}Done.${NC} Hardlinked structure from $src to $dst"
fi
