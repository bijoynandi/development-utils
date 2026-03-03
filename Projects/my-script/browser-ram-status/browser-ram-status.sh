#!/bin/bash
# 📊 Browser RAM Setup Status Dashboard

echo "🚀 BROWSER RAM SETUP STATUS"
echo "=================================="
echo ""

echo "💾 RAM Usage:"
df -h /dev/shm | grep shm
echo ""

echo "📦 Profile Sizes:"
du -sh /dev/shm/firefox-root 2>/dev/null || echo "  Firefox root: Not in RAM"
du -sh /dev/shm/firefox-cache 2>/dev/null || echo "  Firefox cache: Not in RAM"
du -sh /dev/shm/chrome-profile 2>/dev/null || echo "  Chrome: Not in RAM"
echo ""

echo "🔗 Symlinks:"
ls -l ~/.config/mozilla/firefox/*.default* 2>/dev/null | grep "/dev/shm"
ls -l ~/.cache/mozilla/firefox/*.default* 2>/dev/null | grep "/dev/shm"
ls -l ~/.config/google-chrome 2>/dev/null | grep "/dev/shm"
echo ""

echo "🤖 Service Status:"
systemctl is-active firefox-restore-root && echo "  ✅ Firefox root restore: active" || echo "  ❌ Firefox root restore: inactive"
systemctl is-active firefox-restore-cache && echo "  ✅ Firefox cache restore: active" || echo "  ❌ Firefox cache restore: inactive"
systemctl is-active chrome-restore && echo "  ✅ Chrome restore: active" || echo "  ❌ Chrome restore: inactive"
echo ""

echo "📅 Last Saves:"
stat -c "%y" ~/.config/mozilla/firefox/*.backup 2>/dev/null | head -1
stat -c "%y" ~/.config/google-chrome.backup 2>/dev/null | head -1
echo ""

echo "⏰ Cron Jobs:"
echo "Firefox root:"
crontab -l | grep save-firefox-root || echo "  ❌ No Firefox root cron job!"
echo "Firefox cache:"
crontab -l | grep save-firefox-cache || echo "  ❌ No Firefox cache cron job!"
echo "Chrome:"
crontab -l | grep save-chrome || echo "  ❌ No Chrome cron job!"
echo ""
