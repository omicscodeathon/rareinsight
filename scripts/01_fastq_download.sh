#!/bin/bash
 
# Directory for downladed reads
mkdir -p Reads

# Change directory to Scripts
cd Scripts || exit 1

# Read URLs from download.txt and download into Reads directory
while read -r url; do
    wget -c "$url" -P "../Reads"
done < download.txt

