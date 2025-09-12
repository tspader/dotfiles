#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: '$1' is not a directory"
    exit 1
fi

cp -r "$1" /mnt/user/media/books/staging/