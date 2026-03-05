# Development Utilities & Scripts

**Bash scripts and system utilities for productivity and development**

A collection of practical bash scripts and utilities for health monitoring, system management, and development productivity.

---

## 🎯 What This Includes

### Health & Productivity
- **20-20-20 Eye Timer**: Reminds you to rest your eyes every 20 minutes
- **50-10 Timer**: Pomodoro-style work timer (50 min work, 10 min break)

### System Tools
- **Browser RAM Status**: Monitor Firefox/Chrome memory usage
- **Comprehensive Integrity Check**: System file integrity verification
- **System Backup**: Automated backup scripts for home and system partitions

### KDE Utilities
- **Disable Screen Lock**: Temporarily disable KDE screen locking
- **Disable Sleep**: Prevent system sleep during long operations
- **Lock and Turn Off**: Combined lock and display-off utility
- **Remove KDE Bloat**: Clean up unnecessary KDE packages

### Learning Projects
- **C Programs**: Basic C programming examples
  - Hello World
  - Calculator
  - File Tool
- **Bash Scripts**: Learning resources and examples
- **PDF Tools**: Code editor keyboard shortcuts

---

## 🚀 Quick Start

### Installation
```bash
# Clone the repository
git clone git@github.com:bijoynandi/development-utils.git
cd development-utils
```

### Usage

#### Health Timers
```bash
# 20-20-20 Eye Timer (every 20 min, look 20 feet away for 20 sec)
bash Projects/my-script/20-20-20-eye-timer/20-20-20-eye-timer.sh

# 50-10 Work Timer (50 min work, 10 min break)
bash Projects/my-script/50-10-timer/50-10-timer.sh
```

#### System Tools
```bash
# Check browser RAM usage
bash Projects/my-script/browser-ram-status/browser-ram-status.sh

# Run system integrity check
bash Projects/my-script/comprehensive-integrity-check/comprehensive-integrity-check.sh

# Backup system (adjust paths in script first!)
bash Projects/my-script/system-backup/system-backup-hp.sh
```

#### KDE Utilities
```bash
# Temporarily disable screen lock
bash Projects/my-script/disable-screen-lock/disable-screen-lock.sh

# Disable sleep (for downloads, compilations)
bash Projects/my-script/disable-sleep/disable-sleep.sh

# Lock screen and turn off display
bash Projects/my-script/lock-and-turn-off/lock-and-turnoff.sh
```

---

## 📂 Repository Structure
```
development-utils/
├── Projects/
│   └── my-script/
│       ├── 20-20-20-eye-timer/
│       ├── 50-10-timer/
│       ├── browser-ram-status/
│       ├── comprehensive-integrity-check/
│       ├── disable-screen-lock/
│       ├── disable-sleep/
│       ├── lock-and-turn-off/
│       ├── remove-kde-bloat/
│       └── system-backup/
├── Learning/
│   ├── 01-hello-world/      # C: Hello World
│   ├── 02-calculator/       # C: Calculator with Makefile
│   ├── 03-file-tool/        # C: File tool with CMake
│   ├── bash-scripts/        # Bash learning resources
│   └── pdf/                 # Keyboard shortcuts
├── Sources/
│   └── (external dependencies - not tracked)
└── Builds/
    └── (build artifacts - not tracked)
```

---

## 🛠️ Script Details

### Health Timers

**20-20-20 Eye Timer**
- Reminds every 20 minutes
- Desktop notification
- Prevents eye strain during long coding sessions

**50-10 Work Timer**
- 50-minute focused work session
- 10-minute break reminder
- Improves productivity and prevents burnout

### System Tools

**Browser RAM Status**
- Monitors Firefox and Chrome memory usage
- Helps identify memory leaks
- Useful for 32GB RAM optimization

**Comprehensive Integrity Check**
- Verifies system file integrity
- Checks for corruption
- Reports anomalies

**System Backup**
- Automated backup scripts
- Separate scripts for home and system partitions
- Customizable backup locations

### KDE Utilities

**Disable Screen Lock**
- Temporarily disables KDE screen locking
- Useful during presentations or long videos
- Automatic re-enable option

**Disable Sleep**
- Prevents system sleep/suspend
- For long downloads or compilations
- Can be enabled/disabled as needed

**Remove KDE Bloat**
- Removes unnecessary KDE applications
- Frees disk space
- Keeps system lean

---

## 🎓 Learning Projects

### C Programming
Three progressive C projects demonstrating:
1. Basic compilation
2. Makefile usage
3. CMake build system

### Bash Scripting
Collection of bash learning resources:
- Bash Scripts Master (600+ example scripts)
- Notes on bash shell scripting
- Ultimate Bash Script Reference Guide

---

## 📝 Notes

- All scripts tested on Fedora KDE Plasma
- Health timers use `notify-send` for desktop notifications
- System backup scripts need path customization
- KDE utilities require KDE Plasma desktop environment

---

## ⚠️ Important

- Review and customize scripts before running
- Backup scripts require setting correct paths
- Remove bloat script will uninstall packages - review list first
- Some scripts require sudo access

---

## 🤝 Contributing

Personal utility collection, but feel free to:
- Fork and adapt for your needs
- Report bugs or suggest improvements
- Share your own utility scripts

---

## 📜 License

Free and unencumbered software released into the public domain.

---

## ✨ Author

**Bijoy Nandi**
- GitHub: [@bijoynandi](https://github.com/bijoynandi)
- Focus: Productivity & System Optimization

---

*Last updated: March 2026*
