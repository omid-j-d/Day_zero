#!/bin/bash

API="https://PANEL_URL/api/users"
TOKEN="API_TOKEN"
OUT_FILE="/root/keys.txt"

echo "📡 Fetching users..."

> "$OUT_FILE"  # خالی کردن فایل قبلی

START=0
SIZE=1000  # حداکثر مجاز
while :; do
    json=$(curl -s -H "Authorization: Bearer $TOKEN" "$API?size=$SIZE&start=$START")
    
    # چک کردن وجود users
    if ! echo "$json" | jq -e '.response.users' >/dev/null 2>&1; then
        echo "❌ Failed or no users found. Raw response:"
        echo "$json"
        break
    fi

    # استخراج shortUuid ها و اضافه به فایل
    count=$(echo "$json" | jq -r '.response.users[].shortUuid' >> "$OUT_FILE" ; echo $?)
    
    # اگر کمتر از SIZE کاربر آمد یعنی آخر کار است
    fetched=$(echo "$json" | jq '.response.users | length')
    echo "Fetched $fetched users..."
    if [ "$fetched" -lt "$SIZE" ]; then
        break
    fi

    # افزایش start برای batch بعدی
    START=$((START + SIZE))
done

TOTAL=$(wc -l < "$OUT_FILE")
echo "✅ Done"
echo "📦 Total users fetched: $TOTAL"
echo "📁 Output: $OUT_FILE"
