#!/bin/bash
echo "🚫 REMOVING SLEEP OPTIONS FROM EVERYWHERE..."
echo ""

# Step 1: Mask systemd sleep targets
echo "1. Masking systemd sleep targets..."
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Step 2: Configure logind to ignore sleep
echo "2. Configuring logind..."
sudo mkdir -p /etc/systemd
sudo tee -a /etc/systemd/logind.conf > /dev/null << 'EOF'

# Disable all sleep/suspend actions
[Login]
HandlePowerKey=poweroff
HandleSuspendKey=ignore
HandleHibernateKey=ignore
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
IdleAction=ignore
EOF

# Step 3: Restart logind
echo "3. Restarting logind..."
sudo systemctl restart systemd-logind

# Step 4: Configure KDE power management
echo "4. Configuring KDE power management..."
mkdir -p ~/.config
cat > ~/.config/powermanagementprofilesrc << 'EOF'
[AC][SuspendSession]
idleTime=0
suspendThenHibernate=false
suspendType=0

[Battery][SuspendSession]
idleTime=0
suspendThenHibernate=false
suspendType=0

[LowBattery][SuspendSession]
idleTime=0
suspendThenHibernate=false
suspendType=0
EOF

# Step 5: Configure SDDM
echo "5. Configuring SDDM (login screen)..."
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/disable-sleep.conf > /dev/null << 'EOF'
[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot
EOF

echo ""
echo "✅ Sleep disabled everywhere!"
echo ""
echo "Changes made:"
echo "- Masked systemd sleep targets"
echo "- Configured logind to ignore sleep"
echo "- Disabled KDE power management sleep"
echo "- Removed sleep from SDDM login screen"
echo ""
echo "Logout and login for changes to take full effect"
echo "Or reboot: reboot"
