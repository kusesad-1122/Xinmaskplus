#!/system/bin/sh
MOD="/data/adb/modules/xinmaskplus"
STATUS="/data/local/tmp/xmark_up.status"
LOCK="/data/local/tmp/xmark_up.lock"
[ -f "$LOCK" ] && { echo "RUNNING"; exit 0; }
echo "START" > "$STATUS"
setsid sh "$MOD/webroot/xz_worker.sh" >/dev/null 2>&1 &
echo "STARTED"
exit 0
