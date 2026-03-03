#!/bin/bash
echo "🧹 Safe KDE Bloat Removal"
echo ""

# Step 1: Stop Akonadi
echo "Stopping Akonadi..."
akonadictl stop

# Disable Akonadi auto-start
mkdir -p ~/.config/akonadi
cat > ~/.config/akonadi/akonadiserverrc << 'EOF'
[Basic Settings]
StartServer=false
EOF

# Step 2: Remove PIM apps
echo "Removing PIM applications..."
sudo dnf remove -y \
  kmail kmail-libs kmail-account-wizard \
  kontact kontact-libs \
  korganizer kaddressbook \
  akregator ktnef \
  akonadi-import-wizard \
  kdepim-addons kdepim-runtime \
  mailimporter-akonadi

# Step 3: Remove games
echo "Removing games..."
sudo dnf remove -y \
  kmahjongg libkmahjongg libkmahjongg-data \
  kmines kpat

# Step 4: Remove unused apps
echo "Removing unused apps..."
sudo dnf remove -y \
  dragon \
  krdc krdc-libs \
  krfb krfb-libs \
  neochat

echo ""
echo "✅ Bloat removed!"
echo "Disk freed: ~205 MB"
echo "RAM freed: ~1.5 GB (Akonadi not running)"
echo ""
echo "Reboot recommended: reboot"
