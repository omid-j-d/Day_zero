#!/bin/bash

# فایل حاوی تمام keys
KEYS_FILE="keys.txt" 
URL_PANEl="URL"
# فولدر خروجی
OUT_DIR="./snapshots"
mkdir -p "$OUT_DIR"

while read key; do
    echo "Fetching key: $key"
    curl -s "https://$URL_PANEL/$key" -o "$OUT_DIR/$key"
done < "$KEYS_FILE"
