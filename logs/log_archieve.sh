#!/bin/bash
ARCH_DIR="$HOME/archive"
mkdir -p "$ARCH_DIR"

if [ -z "$1" ];then
echo "Invalid Input, Try again!"
exit 1
fi

ARCH_FILE="logs_archive_$(date '+%Y%m%d_%H%M%S').tar.gz"

if [ ! -d "$1" ];then
        echo "There is no such directory!"
	exit 1
fi

if tar -czf "$ARCH_DIR/$ARCH_FILE" -C "$1" . 2>/dev/null ; then
	echo "Compression have been done successfully! "
        echo "Archived at $(date)" >> "$ARCH_DIR/archive.log"
else
    	echo "Error: Compression failed."
    	exit 1
fi
