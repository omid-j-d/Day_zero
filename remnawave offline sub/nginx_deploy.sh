#!/bin/bash

# مسیر snapshot جدید (محلی)
read -p "Enter path to new snapshots (default: /root/snapshots): " LOCAL_SNAP
LOCAL_SNAP=${LOCAL_SNAP:-/root/snapshots}

# مسیر سرور
SERVER_SNAP="/var/www/api-subs"

# کپی snapshot‌ها
cp -r "$LOCAL_SNAP"/* "$SERVER_SNAP/"

# حذف پسوند .key اگر وجود دارد
cd "$SERVER_SNAP"
for f in *.key 2>/dev/null; do
    mv "$f" "${f%.key}"
done

# تنظیم مالکیت و دسترسی
chown -R www-data:www-data "$SERVER_SNAP"
chmod -R 644 "$SERVER_SNAP"/*
chmod 755 "$SERVER_SNAP"

# تست Nginx و Reload
nginx -t && systemctl restart nginx

echo "Deployment completed. Snapshots are live."
