#!/bin/bash
################################################################################
# LOCK AND TURN OFF SCREEN SCRIPT (FIXED - Feb 18, 2026)
################################################################################
#
# PURPOSE:
#   Lock the screen immediately when Meta+L is pressed, then automatically
#   turn off the display after 60 seconds ONLY if still locked.
#
# BUG FIX (Feb 18, 2026):
#   - Previous version: Always turned off screen after 60s even if unlocked!
#   - Fixed version: Checks lock status before turning off screen
#   - If you unlock within 60s → Screen stays on ✅
#   - If still locked after 60s → Screen turns off ✅
#
# WHY THIS EXISTS:
#   - KDE Plasma 6 on Wayland doesn't properly turn off screen when locked
#   - Built-in "Turn off screen when locked" setting is broken
#   - This script provides the desired behavior manually
#
# WHAT IT DOES:
#   1. Locks the screen immediately (you see lock screen)
#   2. Waits 60 seconds (grace period to verify lock)
#   3. CHECKS if screen is STILL LOCKED
#   4. If still locked → Turns off display (saves power)
#   5. If unlocked → Does nothing (screen stays on)
#
# HOW TO USE:
#   - Bound to Meta+L keyboard shortcut via Custom Shortcuts
#   - Press Meta+L when stepping away from desk
#   - Screen locks immediately
#   - After 1 minute (if still locked), display turns off automatically
#   - If you unlock within 1 minute, display stays on!
#   - Move mouse to wake up, enter password to unlock
#
# REQUIREMENTS:
#   - KDE Plasma 6 (Wayland or X11)
#   - qdbus-qt6 command (comes with KDE)
#   - If not installed, install with: sudo dnf install qt6-qttools
#   - Custom Shortcuts configured (see setup instructions below)
#
# SETUP INSTRUCTIONS:
#   1. Make this script executable:
#      chmod +x ~/Documents/Development/Projects/my-script/lock-and-turn-off/lock-and-turnoff.sh
#
#   2. Open System Settings → "Keyboard" → "Shortcuts" → "Session Management" → "Lock Session":
#      - Uncheck Super + L (Meta + L) key → Click Apply
#
#   3. Now click "Add New" on the top right:
#      - Select "Command or Script..." → "Choose..." → Navigate to script → "Add"
#      - Name it: "Lock and Turn Off Screen"
#      - Set shortcut: Meta+L
#
# BEFORE USING THIS SCRIPT:
#   - Remove the default Meta+L binding in System Settings → Shortcuts
#   - Search for "Lock Session" and clear/disable its Meta+L shortcut
#   - This prevents conflicts between default lock and this script
#
# TROUBLESHOOTING:
#   - If screen doesn't lock: Check that qdbus-qt6 is installed
#   - If screen doesn't turn off: Wait full 60 seconds
#   - If screen turns off even after unlocking: This bug is FIXED!
#   - If shortcut doesn't work: Check Custom Shortcuts is running
#   - Test script manually first: Run this file directly to verify
#
# TECHNICAL DETAILS:
#   - Uses qdbus-qt6 to communicate with KDE components
#   - org.freedesktop.ScreenSaver: Standard screen lock D-Bus interface
#   - org.kde.kglobalaccel: KDE's global keyboard shortcut system
#   - GetActive method: Returns "true" if locked, "false" if unlocked
#   - "Turn Off Screen": Built-in KDE power management action
#
# CREATED: 2026-01-01
# FIXED: 2026-02-18 (Added lock status check before turning off)
# LOCATION: ~/Documents/Development/Projects/my-script/lock-and-turn-off/lock-and-turnoff.sh
#
################################################################################

# Lock the screen immediately using KDE's ScreenSaver D-Bus interface
# This shows the lock screen so you can verify the system is locked
qdbus-qt6 org.freedesktop.ScreenSaver /ScreenSaver Lock

# Wait 60 seconds (1 minute grace period)
# This gives you time to see that the screen is locked
# Also prevents accidental immediate screen-off if you change your mind
sleep 60

# CHECK if screen is STILL LOCKED before turning off!
# GetActive returns "true" if locked, "false" if unlocked
LOCKED=$(qdbus-qt6 org.freedesktop.ScreenSaver /ScreenSaver GetActive)

# Only turn off the display if STILL LOCKED
if [ "$LOCKED" = "true" ]; then
    # Still locked after 60 seconds → Turn off display
    # This invokes KDE's built-in "Turn Off Screen" action via D-Bus
    # Works on both Wayland and X11
    # Screen will turn on again when you move mouse/press key
    qdbus-qt6 org.kde.kglobalaccel /component/org_kde_powerdevil invokeShortcut "Turn Off Screen"
fi

# If unlocked within 60 seconds → script ends silently (screen stays on)

################################################################################
# END OF SCRIPT
################################################################################
