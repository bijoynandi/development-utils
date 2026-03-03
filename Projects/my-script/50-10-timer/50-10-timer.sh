#!/bin/bash

# 50-10 Break Timer
# Reminds every 50 minutes to take 10-minute break

while true; do
    # Work period: 50 minutes
    sleep 3000  # 50 minutes = 3000 seconds
    
    # Visual notification - LARGE and CRITICAL
    notify-send -u critical "⏰ BREAK TIME!" "You've worked 50 minutes!\n\n🚶 Stand up NOW!\n💧 Drink water!\n🧘 Stretch 3 minutes!\n\nBreak for 10 minutes!" --icon=appointment-soon
    
    # Play sound
    paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga 2>/dev/null || true
    
    # Break period: 10 minutes
    sleep 600  # 10 minutes = 600 seconds
    
    # Back to work notification
    notify-send "💪 Back to Work!" "Break over! Next break in 50 minutes!" --icon=emblem-default
done
