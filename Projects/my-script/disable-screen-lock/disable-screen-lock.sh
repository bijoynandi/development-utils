#!/bin/bash
# Smart Screen Lock Configuration
# - Never locks automatically (work freely)
# - Never dims/turns off while working
# - Turns off screen 1 min after MANUAL lock (saves power)

echo "🔓 CONFIGURING SMART SCREEN LOCK..."
echo ""

# Disable automatic locking
echo "1. Disabling auto-lock..."
kwriteconfig6 --file kscreenlockerrc --group Daemon --key Autolock false
kwriteconfig6 --file kscreenlockerrc --group Daemon --key LockOnResume false
kwriteconfig6 --file kscreenlockerrc --group Daemon --key Timeout 0

# Disable dimming when unlocked
echo "2. Disabling auto-dim while working..."
kwriteconfig6 --file powermanagementprofilesrc --group "AC" --group "DimDisplay" --key idleTime 0

# Disable screen turn-off when unlocked
echo "3. Disabling screen turn-off while working..."
kwriteconfig6 --file powermanagementprofilesrc --group "AC" --group "DPMSControl" --key idleTime 0

# Enable screen turn-off 1 minute after manual lock
echo "4. Enabling screen turn-off 1 min after manual lock..."
kwriteconfig6 --file kscreenlockerrc --group Daemon --key LockGrace 60000
kwriteconfig6 --file powermanagementprofilesrc --group "AC" --group "DPMSControl" --key lockScreen true
kwriteconfig6 --file powermanagementprofilesrc --group "AC" --group "DPMSControl" --key idleTimeWhenLocked 60

# Disable suspend/sleep
echo "5. Confirming suspend disabled..."
kwriteconfig6 --file powermanagementprofilesrc --group "AC" --group "SuspendSession" --key idleTime 0
kwriteconfig6 --file powermanagementprofilesrc --group "AC" --group "SuspendSession" --key suspendType 0

# Restart Plasma to apply
echo "6. Restarting Plasma shell..."
systemctl --user restart plasma-plasmashell

echo ""
echo "✅ Smart screen lock configured!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Behavior:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "While UNLOCKED (working):"
echo "  ✅ Screen stays on forever"
echo "  ✅ Never dims"
echo "  ✅ Never turns off"
echo "  ✅ Never locks"
echo ""
echo "After MANUAL lock (Super+L):"
echo "  ✅ Screen stays on for 1 minute"
echo "  ✅ Screen turns OFF after 1 minute"
echo "  ✅ Move mouse to turn on → Enter password"
echo ""
echo "Manual controls:"
echo "  🔒 Lock: Super+L"
echo "  ⚡ Shutdown: Super → Leave → Shutdown"
echo "  🖥️  Monitor: Press monitor power button"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
