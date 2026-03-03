#!/bin/bash

# 20-20-20 Eye Rule Timer
# Every 20 minutes, reminds you to look away, close eyes, and blink

while true; do
    # Wait 20 minutes
    sleep 1200  # 20 minutes = 1200 seconds
    
    # Enhanced reminder - CRITICAL PRIORITY!
    notify-send -u critical "👁️ Eye Break Time!" "1️⃣ Look 20 feet away (10 seconds)\n2️⃣ Close your eyes (10 seconds)\n3️⃣ Blink rapidly (5-10 times)\n\nComplete eye rest! 💚" --icon=dialog-information
    
    # Play gentle sound
    paplay /usr/share/sounds/freedesktop/stereo/message-new-instant.oga 2>/dev/null || true
done
