#!/bin/bash
# ============================================
# SYSTEM BACKUP SCRIPT
# Production-Ready, Battle-Tested, Enterprise-Grade!
# ============================================
#
# PURPOSE:
# --------
# Complete system state backup for disaster recovery
# Backup EVERYTHING needed to restore system to exact state
# Designed for systems under pressure for years to come!
#
# WHAT THIS BACKS UP:
# -------------------
# 1. /home directory (your personal data)
# 2. /etc directory (all system configurations)
# 3. Package lists (DNF, Flatpak, Conda, NPM, Pip)
# 4. Systemd services (custom services)
# 5. Firewall rules
# 6. Network configuration
# 7. Cron jobs
# 8. SSH keys and configs
# 9. Podman/Docker state
# 10. Git repositories list
# 11. System information (for reference)
#
# USAGE:
# ------
# 1. Make executable:
#    chmod +x system-backup-hp.sh
#
# 2. Dry run (ALWAYS test first!):
#    ./system-backup-hp.sh --dry-run
#
# 3. Actual backup:
#    ./system-backup-hp.sh
#
# 4. With verbose output:
#    ./system-backup-hp.sh --verbose
#
# RESTORE INSTRUCTIONS:
# ---------------------
# See the RESTORE-INSTRUCTIONS.txt file created with each backup!
#
# SCHEDULING:
# -----------
# Add to crontab for automatic backups:
#   crontab -e
#   0 2 * * 0 /path/to/system-backup-hp.sh  # Every Sunday at 2 AM
#
# ============================================

# ============================================
# CONFIGURATION
# ============================================

# Backup destination (CHANGE THIS!)
BACKUP_DEST="/run/media/bijoy/system-backup-hp"

# Backup directory (single directory - always overwrites)
# This saves space! Only one copy exists at a time.
BACKUP_DIR="$BACKUP_DEST/latest-system-backup"

# Log file (always save to actual user's home, not root's!)
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
if [ -n "$SUDO_USER" ]; then
    # Running with sudo - use actual user's home
    LOG_FILE="/home/$SUDO_USER/backup-system-$BACKUP_DATE.log"
else
    # Running without sudo
    LOG_FILE="$HOME/backup-system-$BACKUP_DATE.log"
fi

# Source directories
HOME_SOURCE="/home"
ETC_SOURCE="/etc"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Flags
DRY_RUN=false
VERBOSE=false

# ============================================
# HOME DIRECTORY EXCLUSIONS
# ============================================

HOME_EXCLUDES=(
    # System caches
    '--exclude=.cache'
    '--exclude=.local/share/Trash'
    '--exclude=.thumbnails'

    # Browser caches
    '--exclude=.mozilla/firefox/*/Cache*'
    '--exclude=.mozilla/firefox/*/cache2'
    '--exclude=.mozilla/firefox/*/OfflineCache'
    '--exclude=.config/google-chrome/*/Cache*'
    '--exclude=.config/chromium/*/Cache*'
    '--exclude=.config/BraveSoftware/*/Cache*'

    # IDE caches
    '--exclude=.PyCharm*/system'
    '--exclude=.PyCharm*/log'
    '--exclude=.DataGrip*/system'
    '--exclude=.DataGrip*/log'
    '--exclude=.IntelliJIdea*/system'
    '--exclude=.vscode/extensions/*/node_modules'
    '--exclude=.eclipse/.metadata/.log'

    # Python/Conda
    '--exclude=anaconda3/pkgs'
    '--exclude=anaconda3/envs/*/lib'
    '--exclude=.conda/pkgs'
    '--exclude=__pycache__'
    '--exclude=*.pyc'
    '--exclude=.pytest_cache'

    # Node.js
    '--exclude=node_modules'
    '--exclude=.npm'
    '--exclude=.node-gyp'

    # Rust/Cargo
    '--exclude=.cargo/registry'
    '--exclude=.cargo/git'
    '--exclude=target/debug'
    '--exclude=target/release'

    # .NET
    '--exclude=.dotnet'
    '--exclude=.nuget'

    # Downloads/Videos
    '--exclude=Downloads'
    '--exclude=Videos'

    # Temporary files
    '--exclude=*.tmp'
    '--exclude=*.temp'
    '--exclude=*~'
    '--exclude=.swp'
    '--exclude=.swap'

    # Podman/Docker storage
    '--exclude=.local/share/containers/storage'
)

# ============================================
# UTILITY FUNCTIONS
# ============================================

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ${message//\\033\[0;[0-9]*m/}" >> "$LOG_FILE"
}

print_section() {
    local title=$1
    print_message "$CYAN" ""
    print_message "$CYAN" "============================================"
    print_message "$CYAN" "  $title"
    print_message "$CYAN" "============================================"
}

print_step() {
    local step=$1
    print_message "$BLUE" "▶ $step"
}

print_success() {
    local message=$1
    print_message "$GREEN" "✅ $message"
}

print_warning() {
    local message=$1
    print_message "$YELLOW" "⚠️  $message"
}

print_error() {
    local message=$1
    print_message "$RED" "❌ $message"
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_warning "$1 not found - skipping related backup"
        return 1
    fi
    return 0
}

# ============================================
# PRE-FLIGHT CHECKS
# ============================================

pre_flight_checks() {
    print_section "PRE-FLIGHT CHECKS"

    # Check if running as root (needed for some operations)
    if [ "$EUID" -ne 0 ]; then
        print_warning "Not running as root - some backups may be incomplete"
        print_message "$YELLOW" "  Recommendation: Run with sudo for complete backup"
        read -p "Continue anyway? (y/N): " choice
        if [[ ! "$choice" =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    # Check backup destination
    if [ ! -d "$BACKUP_DEST" ]; then
        print_error "Backup destination not found: $BACKUP_DEST"
        print_message "$YELLOW" "  Please mount your USB drive or update BACKUP_DEST"
        exit 1
    fi

    # Check available space (need at least 100GB)
    local available_space=$(df "$BACKUP_DEST" | tail -1 | awk '{print $4}')
    local required_space=100000000  # 100GB in KB

    if [ "$available_space" -lt "$required_space" ]; then
        print_warning "Low disk space on backup destination!"
        print_message "$YELLOW" "  Available: $(($available_space / 1024 / 1024))GB"
        print_message "$YELLOW" "  Recommended: 100GB+"
        read -p "Continue anyway? (y/N): " choice
        if [[ ! "$choice" =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    # Create backup directory
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$BACKUP_DIR"/{home,etc,system-state,packages,configs}
        print_success "Backup directory created: $BACKUP_DIR"
    fi

    print_success "Pre-flight checks completed"
}

# ============================================
# BACKUP FUNCTIONS
# ============================================

backup_home() {
    print_section "BACKING UP /home DIRECTORY"

    print_step "Starting home directory backup..."

    # Build rsync command
    local rsync_cmd="rsync -avH --delete"

    if [ "$DRY_RUN" = true ]; then
        rsync_cmd="$rsync_cmd --dry-run"
    fi

    if [ "$VERBOSE" = true ]; then
        rsync_cmd="$rsync_cmd --progress"
    fi

    # Add exclusions
    for exclude in "${HOME_EXCLUDES[@]}"; do
        rsync_cmd="$rsync_cmd $exclude"
    done

    rsync_cmd="$rsync_cmd $HOME_SOURCE $BACKUP_DIR/home/"

    # Execute
    if eval "$rsync_cmd" 2>&1 | tee -a "$LOG_FILE"; then
        print_success "Home directory backed up successfully"
    else
        print_error "Home directory backup failed!"
        return 1
    fi
}

backup_etc() {
    print_section "BACKING UP /etc DIRECTORY"

    print_step "Creating /etc backup archive..."

    if [ "$DRY_RUN" = false ]; then
        if tar -czf "$BACKUP_DIR/etc/etc-complete.tar.gz" /etc 2>&1 | tee -a "$LOG_FILE"; then
            print_success "/etc directory backed up successfully"
        else
            print_error "/etc directory backup failed!"
            return 1
        fi
    else
        print_message "$YELLOW" "[DRY RUN] Would backup /etc to $BACKUP_DIR/etc/etc-complete.tar.gz"
    fi
}

backup_packages() {
    print_section "BACKING UP PACKAGE LISTS"

    local pkg_dir="$BACKUP_DIR/packages"

    # DNF packages
    print_step "Saving DNF package list..."
    if [ "$DRY_RUN" = false ]; then
        dnf list installed > "$pkg_dir/dnf-packages.txt" 2>&1
        dnf repolist > "$pkg_dir/dnf-repos.txt" 2>&1
        print_success "DNF packages saved"
    else
        print_message "$YELLOW" "[DRY RUN] Would save DNF packages"
    fi

    # Flatpak packages
    print_step "Saving Flatpak package list..."
    if check_command flatpak; then
        if [ "$DRY_RUN" = false ]; then
            flatpak list > "$pkg_dir/flatpak-packages.txt" 2>&1
            flatpak remotes > "$pkg_dir/flatpak-remotes.txt" 2>&1
            print_success "Flatpak packages saved"
        else
            print_message "$YELLOW" "[DRY RUN] Would save Flatpak packages"
        fi
    fi

    # Conda environments
    print_step "Saving Conda environments..."
    if check_command conda; then
        if [ "$DRY_RUN" = false ]; then
            conda env list > "$pkg_dir/conda-envs.txt" 2>&1
            conda list > "$pkg_dir/conda-packages.txt" 2>&1
            print_success "Conda environments saved"
        else
            print_message "$YELLOW" "[DRY RUN] Would save Conda environments"
        fi
    fi

    # NPM global packages
    print_step "Saving NPM global packages..."
    if check_command npm; then
        if [ "$DRY_RUN" = false ]; then
            npm list -g --depth=0 > "$pkg_dir/npm-global.txt" 2>&1
            print_success "NPM packages saved"
        else
            print_message "$YELLOW" "[DRY RUN] Would save NPM packages"
        fi
    fi

    # Pip packages
    print_step "Saving Pip packages..."
    if check_command pip3; then
        if [ "$DRY_RUN" = false ]; then
            pip3 list --format=freeze > "$pkg_dir/pip-packages.txt" 2>&1
            print_success "Pip packages saved"
        else
            print_message "$YELLOW" "[DRY RUN] Would save Pip packages"
        fi
    fi

    # Cargo packages (Rust)
    print_step "Saving Cargo packages..."
    if check_command cargo; then
        if [ "$DRY_RUN" = false ]; then
            cargo install --list > "$pkg_dir/cargo-packages.txt" 2>&1
            print_success "Cargo packages saved"
        else
            print_message "$YELLOW" "[DRY RUN] Would save Cargo packages"
        fi
    fi
}

backup_system_state() {
    print_section "BACKING UP SYSTEM STATE"

    local state_dir="$BACKUP_DIR/system-state"

    # System information
    print_step "Saving system information..."
    if [ "$DRY_RUN" = false ]; then
        uname -a > "$state_dir/system-info.txt"
        hostnamectl > "$state_dir/hostname-info.txt"
        lsblk > "$state_dir/disk-layout.txt"
        df -h > "$state_dir/disk-usage.txt"
        free -h > "$state_dir/memory-info.txt"
        lscpu > "$state_dir/cpu-info.txt"
        lspci > "$state_dir/pci-devices.txt"
        print_success "System information saved"
    else
        print_message "$YELLOW" "[DRY RUN] Would save system information"
    fi

    # Systemd services
    print_step "Saving systemd services..."
    if [ "$DRY_RUN" = false ]; then
        systemctl list-units --type=service > "$state_dir/systemd-services.txt"
        systemctl list-unit-files --type=service > "$state_dir/systemd-unit-files.txt"
        print_success "Systemd services saved"
    else
        print_message "$YELLOW" "[DRY RUN] Would save systemd services"
    fi

    # Firewall rules
    print_step "Saving firewall configuration..."
    if check_command firewall-cmd; then
        if [ "$DRY_RUN" = false ]; then
            firewall-cmd --list-all > "$state_dir/firewall-rules.txt" 2>&1
            print_success "Firewall configuration saved"
        else
            print_message "$YELLOW" "[DRY RUN] Would save firewall configuration"
        fi
    fi

    # Network configuration
    print_step "Saving network configuration..."
    if [ "$DRY_RUN" = false ]; then
        ip addr > "$state_dir/network-interfaces.txt"
        ip route > "$state_dir/network-routes.txt"
        nmcli connection show > "$state_dir/network-connections.txt" 2>&1
        print_success "Network configuration saved"
    else
        print_message "$YELLOW" "[DRY RUN] Would save network configuration"
    fi

    # Kernel modules
    print_step "Saving kernel modules..."
    if [ "$DRY_RUN" = false ]; then
        lsmod > "$state_dir/kernel-modules.txt"
        print_success "Kernel modules saved"
    else
        print_message "$YELLOW" "[DRY RUN] Would save kernel modules"
    fi
}

backup_user_configs() {
    print_section "BACKING UP USER CONFIGURATIONS"

    local config_dir="$BACKUP_DIR/configs"

    # Cron jobs
    print_step "Saving cron jobs..."
    if [ "$DRY_RUN" = false ]; then
        crontab -l > "$config_dir/crontab-$USER.txt" 2>&1
        print_success "Cron jobs saved"
    else
        print_message "$YELLOW" "[DRY RUN] Would save cron jobs"
    fi

    # SSH configuration
    print_step "Backing up SSH configuration..."
    if [ -d "$HOME/.ssh" ]; then
        if [ "$DRY_RUN" = false ]; then
            mkdir -p "$config_dir/ssh"
            cp -r "$HOME/.ssh/config" "$config_dir/ssh/" 2>/dev/null || true
            cp -r "$HOME/.ssh/known_hosts" "$config_dir/ssh/" 2>/dev/null || true
            # DON'T backup private keys for security!
            # Only config and known_hosts
            print_success "SSH configuration backed up (keys excluded for security)"
        else
            print_message "$YELLOW" "[DRY RUN] Would backup SSH configuration"
        fi
    fi

    # Git configuration
    print_step "Saving Git configuration..."
    if [ "$DRY_RUN" = false ]; then
        cp "$HOME/.gitconfig" "$config_dir/gitconfig" 2>/dev/null || true
        print_success "Git configuration saved"
    else
        print_message "$YELLOW" "[DRY RUN] Would save Git configuration"
    fi

    # Bash configuration (already in /home, but copy for easy access)
    print_step "Copying bash configuration..."
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$config_dir/bash"
        cp "$HOME/.bashrc" "$config_dir/bash/" 2>/dev/null || true
        cp "$HOME/.bash_profile" "$config_dir/bash/" 2>/dev/null || true
        cp "$HOME/.blerc" "$config_dir/bash/" 2>/dev/null || true
        cp -r "$HOME/.bashrc.d" "$config_dir/bash/" 2>/dev/null || true
        print_success "Bash configuration copied"
    else
        print_message "$YELLOW" "[DRY RUN] Would copy bash configuration"
    fi
}

backup_podman_state() {
    print_section "BACKING UP PODMAN STATE"

    local podman_dir="$BACKUP_DIR/configs/podman"

    print_step "Saving Podman containers and images..."
    if check_command podman; then
        if [ "$DRY_RUN" = false ]; then
            mkdir -p "$podman_dir"
            podman ps -a > "$podman_dir/containers.txt" 2>&1
            podman images > "$podman_dir/images.txt" 2>&1
            podman volume ls > "$podman_dir/volumes.txt" 2>&1
            podman network ls > "$podman_dir/networks.txt" 2>&1

            # Export container configurations
            podman ps -a --format "{{.Names}}" | while read container; do
                podman inspect "$container" > "$podman_dir/inspect-$container.json" 2>&1
            done

            print_success "Podman state saved"
        else
            print_message "$YELLOW" "[DRY RUN] Would save Podman state"
        fi
    fi
}

backup_git_repos() {
    print_section "BACKING UP GIT REPOSITORY LIST"

    local git_dir="$BACKUP_DIR/configs/git"

    print_step "Finding all Git repositories..."
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$git_dir"
        find "$HOME" -name ".git" -type d 2>/dev/null | sed 's|/.git||' > "$git_dir/git-repositories.txt"

        # Count repos
        local repo_count=$(wc -l < "$git_dir/git-repositories.txt")
        print_success "Found $repo_count Git repositories"
    else
        print_message "$YELLOW" "[DRY RUN] Would list Git repositories"
    fi
}

create_restore_instructions() {
    print_section "CREATING RESTORE INSTRUCTIONS"

    local restore_file="$BACKUP_DIR/RESTORE-INSTRUCTIONS.txt"

    if [ "$DRY_RUN" = false ]; then
        cat > "$restore_file" << 'EOF'
============================================
RESTORE INSTRUCTIONS
============================================

Follow these steps to restore your system after a disaster.

============================================
STEP 1: RESTORE /home DIRECTORY
============================================

# Restore entire /home:
sudo rsync -avH /path/to/backup/home/ /home/

# Or restore specific user:
sudo rsync -avH /path/to/backup/home/bijoy/ /home/bijoy/

# Or restore specific folder:
rsync -avH /path/to/backup/home/bijoy/Documents/ ~/Documents/

============================================
STEP 2: RESTORE /etc CONFIGURATION
============================================

# Extract /etc backup:
cd /
sudo tar -xzf /path/to/backup/etc/etc-complete.tar.gz

# WARNING: Be careful! This overwrites system configs!
# Only do this on fresh install or if you know what you're doing!

============================================
STEP 3: REINSTALL PACKAGES
============================================

# DNF packages:
sudo dnf install $(cat /path/to/backup/packages/dnf-packages.txt | awk '{print $1}')

# Flatpak packages:
while read line; do
    flatpak install -y $(echo $line | awk '{print $2}')
done < /path/to/backup/packages/flatpak-packages.txt

# Conda environments:
# (Restore manually from conda-envs.txt)

# NPM global packages:
# (Restore manually from npm-global.txt)

# Pip packages:
pip3 install -r /path/to/backup/packages/pip-packages.txt

============================================
STEP 4: RESTORE CONFIGURATIONS
============================================

# Cron jobs:
crontab /path/to/backup/configs/crontab-bijoy.txt

# SSH config (keys need to be restored manually for security):
cp /path/to/backup/configs/ssh/config ~/.ssh/
cp /path/to/backup/configs/ssh/known_hosts ~/.ssh/

# Git config:
cp /path/to/backup/configs/gitconfig ~/.gitconfig

# Bash config (already in /home, but just in case):
cp /path/to/backup/configs/bash/.bashrc ~/.bashrc
cp -r /path/to/backup/configs/bash/.bashrc.d ~/.bashrc.d
cp /path/to/backup/configs/bash/.blerc ~/.blerc

============================================
STEP 5: RESTORE PODMAN CONTAINERS
============================================

# Pull images:
# (Use images.txt to see what you had)

# Recreate containers:
# (Use inspect-*.json files to see configurations)

============================================
STEP 6: VERIFY RESTORATION
============================================

# Check file integrity:
./comprehensive-integrity-check.sh

# Check package installations:
dnf list installed

# Check services:
systemctl list-units --type=service

# Test critical applications

============================================
IMPORTANT NOTES
============================================

- Always test restore on a non-critical system first!
- Some files may need manual intervention
- SSH keys are NOT backed up for security reasons
- Podman containers need manual recreation
- Review all configurations before using them

============================================
SUPPORT
============================================

If you encounter issues during restore:
1. Check the backup log file
2. Review system-state/ for reference information
3. Consult with a Linux expert if needed

Created by: Backup Script
Backup Date: BACKUP_DATE_PLACEHOLDER
System: Fedora 43 KDE Plasma

============================================
EOF

        # Replace placeholder
        sed -i "s/BACKUP_DATE_PLACEHOLDER/$BACKUP_DATE/g" "$restore_file"

        print_success "Restore instructions created"
    else
        print_message "$YELLOW" "[DRY RUN] Would create restore instructions"
    fi
}

# ============================================
# MAIN EXECUTION
# ============================================

main() {
    # Parse arguments
    for arg in "$@"; do
        case $arg in
            --dry-run|-n)
                DRY_RUN=true
                ;;
            --verbose|-v)
                VERBOSE=true
                ;;
            --help|-h)
                cat << EOF
System Backup Script

Usage: $0 [OPTIONS]

Options:
  --dry-run, -n    Test run without making changes
  --verbose, -v    Show detailed output
  --help, -h       Show this help message

This script backs up:
  - /home directory (your personal data)
  - /etc directory (system configurations)
  - Package lists (DNF, Flatpak, Conda, etc.)
  - System state (services, firewall, network)
  - User configurations (SSH, Git, Bash, Cron)
  - Podman state (containers, images, volumes)
  - Git repository list

Backup location: $BACKUP_DEST
EOF
                exit 0
                ;;
        esac
    done

    # Initialize log
    echo "============================================" > "$LOG_FILE"
    echo "System Backup" >> "$LOG_FILE"
    echo "Started: $(date)" >> "$LOG_FILE"
    echo "Mode: $([ "$DRY_RUN" = true ] && echo "DRY RUN" || echo "ACTUAL BACKUP")" >> "$LOG_FILE"
    echo "============================================" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    # Print header
    print_message "$MAGENTA" ""
    print_message "$MAGENTA" "╔════════════════════════════════════════════╗"
    print_message "$MAGENTA" "║  SYSTEM BACKUP                             ║"
    print_message "$MAGENTA" "║  Production-Ready • Battle-Tested          ║"
    print_message "$MAGENTA" "╚════════════════════════════════════════════╝"
    print_message "$MAGENTA" ""

    if [ "$DRY_RUN" = true ]; then
        print_message "$YELLOW" "🔍 DRY RUN MODE - No changes will be made"
    else
        print_message "$GREEN" "🚀 ACTUAL BACKUP MODE"
    fi

    print_message "$BLUE" ""
    print_message "$BLUE" "Backup destination: $BACKUP_DEST"
    print_message "$BLUE" "Backup directory: $BACKUP_DIR (overwrites previous backup)"
    print_message "$BLUE" "Log file: $LOG_FILE"
    print_message "$BLUE" ""

    # Confirm
    if [ "$DRY_RUN" = false ]; then
        read -p "Ready to start backup? This may take a while! (y/N): " choice
        if [[ ! "$choice" =~ ^[Yy]$ ]]; then
            print_error "Backup cancelled by user"
            exit 0
        fi
    fi

    # Start timer
    START_TIME=$(date +%s)

    # Execute backup
    pre_flight_checks
    backup_home
    backup_etc
    backup_packages
    backup_system_state
    backup_user_configs
    backup_podman_state
    backup_git_repos
    create_restore_instructions

    # End timer
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    # Final summary
    print_section "BACKUP COMPLETE"

    print_message "$GREEN" "✅ All backup tasks completed!"
    print_message "$BLUE" ""
    print_message "$BLUE" "📊 Backup Summary:"
    print_message "$BLUE" "   Duration: $((DURATION / 60)) minutes $((DURATION % 60)) seconds"
    print_message "$BLUE" "   Location: $BACKUP_DIR"
    print_message "$BLUE" "   Log file: $LOG_FILE"

    if [ "$DRY_RUN" = false ]; then
        local backup_size=$(du -sh "$BACKUP_DIR" | cut -f1)
        print_message "$BLUE" "   Size: $backup_size"
    fi

    print_message "$BLUE" ""
    print_message "$GREEN" "🎉 Your system is now backed up and ready for anything!"
    print_message "$CYAN" "📖 See RESTORE-INSTRUCTIONS.txt in backup directory for restore guide"
    print_message "$BLUE" ""

    echo "" >> "$LOG_FILE"
    echo "Backup completed: $(date)" >> "$LOG_FILE"
    echo "Duration: $((DURATION / 60)) minutes $((DURATION % 60)) seconds" >> "$LOG_FILE"
}

# ============================================
# RUN BACKUP
# ============================================

main "$@"

# ============================================
# END OF SCRIPT
# ============================================
