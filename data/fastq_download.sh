#!/bin/bash

while read url; do
  wget -c "$url"
done < download.txt
