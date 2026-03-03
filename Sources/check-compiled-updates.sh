#!/bin/bash
# ============================================
# COMPILED SOFTWARE UPDATE CHECKER
# Check for updates to self-compiled tools
# ============================================
#
# USAGE:
# ------
# ./check-compiled-updates.sh
#
# Run this every 6 months or so!
# ============================================

echo "============================================"
echo "📦 CHECKING COMPILED SOFTWARE UPDATES"
echo "============================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================
# BLE.SH
# ============================================
echo -e "${CYAN}Checking ble.sh...${NC}"

if [[ -d ~/Documents/Development/Sources/ble.sh ]]; then
    cd ~/Documents/Development/Sources/ble.sh

    # Current version
    CURRENT_VERSION="$BLE_VERSION"
    echo "  Current: $CURRENT_VERSION"

    # Fetch latest
    echo "  Fetching latest info from GitHub..."
    git fetch origin --quiet

    # Check if updates available
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/master)

    if [ "$LOCAL" = "$REMOTE" ]; then
        echo -e "  ${GREEN}✅ Up to date!${NC}"
    else
        echo -e "  ${YELLOW}📦 Updates available!${NC}"
        echo ""
        echo "  To update:"
        echo "    cd ~/Documents/Development/Sources/ble.sh"
        echo "    git pull"
        echo "    git submodule update --init --recursive"
        echo "    make clean && make"
        echo "    make install PREFIX=~/.local"
        echo "    source ~/.bashrc"
        echo ""
    fi
else
    echo "  ❌ Not installed or not found"
fi

echo ""

# ============================================
# ADD MORE COMPILED SOFTWARE HERE
# ============================================
# Example for bat (if you compile it):
# echo -e "${CYAN}Checking bat...${NC}"
# if [[ -d ~/Documents/Development/Sources/bat ]]; then
#     cd ~/Documents/Development/Sources/bat
#     CURRENT=$(bat --version | awk '{print $2}')
#     echo "  Current: $CURRENT"
#     git fetch origin --quiet
#     LATEST_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
#     echo "  Latest: $LATEST_TAG"
#     if [ "v$CURRENT" = "$LATEST_TAG" ]; then
#         echo -e "  ${GREEN}✅ Up to date!${NC}"
#     else
#         echo -e "  ${YELLOW}📦 Update available!${NC}"
#     fi
# fi
# echo ""

echo "============================================"
echo "✅ Check complete!"
echo "============================================"
echo ""
echo "💡 TIP: Run this script every 6 months!"
echo "📅 Add to calendar: June & December"
echo ""
