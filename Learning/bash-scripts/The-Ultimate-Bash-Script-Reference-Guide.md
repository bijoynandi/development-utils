# 🚀 THE ULTIMATE BASH SCRIPTS REFERENCE GUIDE
## Your Complete Professional Bash Script Collection

**By Excellence Nandi (Bijoy Nandi)** 💚
**112 Production-Grade Scripts Reviewed & Categorized**

---

## 📋 TABLE OF CONTENTS

1. [Introduction](#introduction)
2. [Quick Start Guide](#quick-start-guide)
3. [Installation Instructions](#installation-instructions)
4. [Scripts by Category](#scripts-by-category)
5. [Top 20 Must-Have Scripts](#top-20-must-have-scripts)
6. [Daily Workflow Scripts](#daily-workflow-scripts)
7. [Advanced Usage Tips](#advanced-usage-tips)
8. [Script Quality Ratings](#script-quality-ratings)
9. [Learning Path](#learning-path)
10. [Troubleshooting](#troubleshooting)

---

## 📖 INTRODUCTION

This collection contains **112 professional-grade bash scripts** covering:
- System monitoring and administration
- File processing and manipulation
- Git version control automation
- Media conversion and processing
- Development utilities
- Text processing and analysis

**Overall Quality Rating:** 8.0/10 ⭐⭐⭐⭐

**Quality Distribution:**
- 🏆 Exceptional (10/10): 14 scripts
- ⭐ Excellent (9/10): 20 scripts
- 💚 Very Good (8/10): 28 scripts
- ✅ Good (7/10): 35 scripts
- 📝 Decent (6/10): 15 scripts

---

## 🚀 QUICK START GUIDE

### Step 1: Install Scripts
```bash
# Go to your scripts directory
cd ~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src

# Make all scripts executable
chmod +x *.sh

# Copy useful scripts to your local bin
cp cpu_usage.sh disk_usage.sh extract.sh ~/.local/bin/

# Test one
./cpu_usage.sh
```

### Step 2: Add to PATH (if not already)
```bash
# Add to ~/.bashrc if not present
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Step 3: Start Using!
```bash
# Extract any archive
extract myfile.tar.gz

# Check CPU usage
cpu_usage.sh

# Find orphan processes
orphans.sh --verbose
```

---

## 💾 INSTALLATION INSTRUCTIONS

### Method 1: Copy to ~/.local/bin (Recommended)
```bash
# Create directory if it doesn't exist
mkdir -p ~/.local/bin

# Copy scripts you want to use globally
cp script-name.sh ~/.local/bin/

# Make executable
chmod +x ~/.local/bin/script-name.sh

# Use without .sh extension
cd ~/.local/bin
mv script-name.sh script-name
```

### Method 2: Keep in Learning Directory
```bash
# Your current setup
cd ~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src

# Make all executable
find . -name "*.sh" -exec chmod +x {} \;

# Use with full path
./script-name.sh
```

### Method 3: Create Aliases
```bash
# Add to your ~/.bashrc.d/aliases.sh
alias cpucheck='~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src/cpu_usage.sh'
alias diskcheck='~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src/disk_usage.sh'
```

---

## 📁 SCRIPTS BY CATEGORY

### 🖥️ SYSTEM MONITORING (10/10 Quality)

#### cpu_temp.sh ⭐ 10/10
**Purpose:** Monitor CPU temperature with JSON output
**Features:** Multi-platform (Linux/macOS/FreeBSD), Celsius/Fahrenheit/Kelvin
**Usage:**
```bash
./cpu_temp.sh                    # Show temperature
./cpu_temp.sh -u fahrenheit      # Fahrenheit
./cpu_temp.sh --json             # JSON output
```

#### cpu_usage.sh ⭐ 10/10
**Purpose:** Detailed CPU usage analysis
**Features:** Per-core details, process filtering, JSON output
**Usage:**
```bash
./cpu_usage.sh                   # Overall usage
./cpu_usage.sh --per-core        # Each core
./cpu_usage.sh --json            # JSON format
```

#### disk_usage.sh ⭐ 10/10
**Purpose:** Comprehensive disk space analysis
**Features:** Sorting, filtering, JSON/CSV output
**Usage:**
```bash
./disk_usage.sh                  # All disks
./disk_usage.sh --sort size      # By size
./disk_usage.sh --threshold 80   # Alert at 80%
```

#### ram_memory.sh ⭐ 9/10
**Purpose:** RAM monitoring with alerts
**Features:** JSON output, critical level warnings
**Usage:**
```bash
./ram_memory.sh                  # Basic info
./ram_memory.sh --critical 90    # Alert at 90%
./ram_memory.sh --json           # JSON format
```

#### system_info.sh ⭐ 9/10
**Purpose:** Complete system information
**Features:** Modular display (memory, disk, CPU, network)
**Usage:**
```bash
./system_info.sh --all           # Everything
./system_info.sh --memory --cpu  # Selected info
./system_info.sh --disk          # Disk only
```

---

### 🔍 PROCESS MANAGEMENT (10/10 Quality)

#### zombies.sh ⭐ 10/10 🏆 **MASTERPIECE!**
**Purpose:** Detect and monitor zombie processes
**Features:** Watch mode, parent tracking, process tree
**Usage:**
```bash
./zombies.sh                     # List zombies
./zombies.sh --verbose           # Detailed info
./zombies.sh --watch             # Monitor continuously
./zombies.sh --parents           # Show parent processes
./zombies.sh --tree              # Process tree
```

#### orphans.sh ⭐ 10/10
**Purpose:** Find orphaned processes
**Features:** Verbose mode, count, user filtering
**Usage:**
```bash
./orphans.sh                     # All orphans
./orphans.sh --verbose           # Details
./orphans.sh --count             # Just count
./orphans.sh --user              # Current user only
```

#### program_on_port.sh ⭐ 7/10
**Purpose:** Check what's running on a port
**Usage:**
```bash
./program_on_port.sh 8080        # Check port 8080
./program_on_port.sh 3000        # Check port 3000
```

---

### 📦 FILE OPERATIONS (9-10/10 Quality)

#### extract.sh ⭐ 9/10 **ESSENTIAL!**
**Purpose:** Universal archive extractor
**Supports:** tar, gz, bz2, zip, rar, 7z, xz
**Usage:**
```bash
./extract.sh file.tar.gz         # Extract tar.gz
./extract.sh file.zip            # Extract zip
./extract.sh file.7z             # Extract 7z
```

#### swap_files.sh ⭐ 9/10
**Purpose:** Swap contents of two files
**Features:** Backup support, verbose mode
**Usage:**
```bash
./swap_files.sh file1 file2      # Basic swap
./swap_files.sh -b file1 file2   # With backup
./swap_files.sh -v file1 file2   # Verbose
```

#### rename_extension.sh ⭐ 7/10
**Purpose:** Batch rename file extensions
**Usage:**
```bash
./rename_extension.sh ~/Documents .txt .md  # .txt → .md
```

#### correct_file_names.sh ⭐ 10/10
**Purpose:** Sanitize filenames (remove special chars)
**Features:** Exclusions, hidden files, configurable
**Usage:**
```bash
./correct_file_names.sh ~/Downloads          # Fix all
./correct_file_names.sh --hidden ~/Downloads # Include hidden
```

---

### 🧹 TEXT PROCESSING (8-10/10 Quality)

#### remove_trailing_whitespaces.sh ⭐ 9/10
**Purpose:** Clean trailing whitespace from files
**Features:** Check mode, recursive
**Usage:**
```bash
./remove_trailing_whitespaces.sh file.txt     # Fix file
./remove_trailing_whitespaces.sh --check .    # Check all
```

#### remove_duplicate_lines.sh ⭐ 7/10
**Purpose:** Remove duplicate lines from file
**Usage:**
```bash
./remove_duplicate_lines.sh file.txt
```

#### remove_empty_lines.sh ⭐ 6/10
**Purpose:** Remove empty/whitespace-only lines
**Usage:**
```bash
./remove_empty_lines.sh file.txt
```

#### remove_carriage_return.sh ⭐ 8/10
**Purpose:** Fix Windows line endings (CRLF → LF)
**Features:** Check mode, recursive
**Usage:**
```bash
./remove_carriage_return.sh file.txt          # Fix
./remove_carriage_return.sh --check .         # Check all
```

#### word_histogram.sh ⭐ 8/10
**Purpose:** Word frequency analysis
**Features:** JSON output, parallel processing
**Usage:**
```bash
./word_histogram.sh file.txt                  # Frequency count
./word_histogram.sh -l 3 file.txt             # Words ≥3 chars
./word_histogram.sh -j file.txt               # JSON output
```

---

### 🎬 MEDIA CONVERSION (7-10/10 Quality)

#### convert_to_mp4.sh ⭐ 9/10
**Purpose:** Convert videos to MP4
**Features:** Robust error handling, logging
**Usage:**
```bash
./convert_to_mp4.sh video.avi                 # Convert to MP4
```

#### convert_to_gif.sh ⭐ 9/10
**Purpose:** Convert video to animated GIF
**Usage:**
```bash
./convert_to_gif.sh video.mp4 output.gif
```

#### youtube_to_mp3.sh ⭐ 9/10
**Purpose:** Download YouTube audio
**Features:** Playlist support, auto-dependencies
**Usage:**
```bash
./youtube_to_mp3.sh "https://youtu.be/VIDEO_ID"
./youtube_to_mp3.sh "PLAYLIST_URL"           # Entire playlist
```

#### speed_up_video.sh ⭐ 7/10
**Purpose:** Speed up video playback
**Usage:**
```bash
./speed_up_video.sh video.mp4 2.0            # 2x speed
./speed_up_video.sh video.mp4 1.5            # 1.5x speed
```

#### make_short.sh ⭐ 10/10
**Purpose:** Create YouTube Shorts (9:16 aspect)
**Features:** Auto-crop, safe margins, multiple fit modes
**Usage:**
```bash
./make_short.sh input.mp4                    # Basic short
./make_short.sh --fit cover input.mp4        # Cover mode
```

---

### 🔧 GIT UTILITIES (7-9/10 Quality)

#### change_commit_date.sh ⭐ 9/10
**Purpose:** Modify commit dates
**Usage:**
```bash
./change_commit_date.sh "2024-01-01 12:00:00"
```

#### remove_branch.sh ⭐ 7/10
**Purpose:** Delete branch locally and remotely
**Usage:**
```bash
./remove_branch.sh feature-branch
```

#### remove_n_last_commits.sh ⭐ 8/10
**Purpose:** Remove last N commits
**Usage:**
```bash
./remove_n_last_commits.sh 5 main           # Remove 5 commits
```

#### squash_n_last_commits.sh ⭐ 8/10
**Purpose:** Squash last N commits
**Usage:**
```bash
./squash_n_last_commits.sh 3 develop        # Squash 3 commits
```

#### reset_to_origin.sh ⭐ 8/10
**Purpose:** Hard reset to remote state
**Usage:**
```bash
./reset_to_origin.sh main .                 # Reset to origin/main
```

#### contributions_by_git_author.sh ⭐ 8/10
**Purpose:** Count commits per author
**Usage:**
```bash
./contributions_by_git_author.sh            # All authors
```

---

### 🧮 MATH & UTILITIES (6-8/10 Quality)

#### sqrt.sh ⭐ 7/10
**Purpose:** Calculate square root
**Usage:**
```bash
./sqrt.sh 16                                # Output: 4
./sqrt.sh 2 5                               # 5 decimal places
```

#### factorial.sh ⭐ 7/10
**Purpose:** Calculate factorial
**Usage:**
```bash
./factorial.sh 5                            # Output: 120
```

#### sum_args.sh ⭐ 6/10
**Purpose:** Sum all arguments
**Usage:**
```bash
./sum_args.sh 1 2 3 4 5                     # Output: 15
```

#### arith_mean.sh ⭐ 7/10
**Purpose:** Calculate arithmetic mean
**Usage:**
```bash
./arith_mean.sh 10 20 30                    # Output: 20
```

#### arithmetic_operations.sh ⭐ 8/10
**Purpose:** Advanced calculator with bc
**Usage:**
```bash
./arithmetic_operations.sh "5 + 3 * 2"      # Output: 11
```

---

### 🐍 PYTHON TOOLS (8-10/10 Quality)

#### strip_python_comments.sh ⭐ 10/10
**Purpose:** Remove comments from Python files
**Features:** Tokenizer-based, backup, dry-run
**Usage:**
```bash
./strip_python_comments.sh file.py          # Clean file
./strip_python_comments.sh -n file.py       # Dry run
./strip_python_comments.sh -i *.py          # Interactive
```

#### dead_code.sh ⭐ 10/10
**Purpose:** Find dead code in Python projects
**Features:** JSON/CSV output, statistics
**Usage:**
```bash
./dead_code.sh ~/project                    # Find dead code
./dead_code.sh --json ~/project             # JSON output
```

#### purge_pip.sh ⭐ 9/10
**Purpose:** Safely uninstall Python packages
**Features:** Backup, exclude/include, dry-run
**Usage:**
```bash
./purge_pip.sh                              # All packages
./purge_pip.sh --exclude numpy,pandas       # Keep some
./purge_pip.sh --dry-run                    # Test first
```

#### release_package.sh ⭐ 10/10
**Purpose:** Automate Python package release
**Features:** TestPyPI/PyPI, tests, validation
**Usage:**
```bash
./release_package.sh --test                 # Upload to TestPyPI
./release_package.sh --production           # Upload to PyPI
```

---

### 🎨 CODE FORMATTING (8-10/10 Quality)

#### beautify_script.sh ⭐ 10/10
**Purpose:** Format bash scripts with beautysh + shellcheck
**Usage:**
```bash
./beautify_script.sh script.sh              # Format script
```

#### strip_cpp_comments.sh ⭐ 10/10
**Purpose:** Remove C/C++ comments (pure bash FSM!)
**Usage:**
```bash
./strip_cpp_comments.sh file.cpp            # Clean file
./strip_cpp_comments.sh -r '\.h$' include/  # All headers
```

---

### 🌐 NETWORK & WEB (7-8/10 Quality)

#### ip_info.sh ⭐ 10/10
**Purpose:** Get public/private IP + geolocation
**Features:** JSON output
**Usage:**
```bash
./ip_info.sh                                # All info
./ip_info.sh --json                         # JSON format
```

#### display_weather.sh ⭐ 7/10
**Purpose:** Display weather using wttr.in
**Usage:**
```bash
./display_weather.sh                        # Local weather
```

#### fetch_github_repos_names.sh ⭐ 9/10
**Purpose:** List GitHub repos
**Features:** Pagination, token auth
**Usage:**
```bash
./fetch_github_repos_names.sh username      # Public repos
./fetch_github_repos_names.sh username TOKEN # Private too
```

---

### 🧪 DEVELOPMENT UTILITIES (7-9/10 Quality)

#### time_execution.sh ⭐ 7/10
**Purpose:** Benchmark command execution
**Usage:**
```bash
./time_execution.sh 'ls -la' 100            # Average over 100 runs
```

#### timer.sh ⭐ 6/10
**Purpose:** Simple stopwatch timer
**Usage:**
```bash
./timer.sh                                  # Start timer (Ctrl+C to stop)
```

---

### 🎯 SYSTEM ADMINISTRATION (8-10/10 Quality)

#### empty_trash.sh ⭐ 10/10
**Purpose:** Empty trash for all users
**Features:** Multi-user, simulation mode, cross-platform
**Usage:**
```bash
./empty_trash.sh                            # Empty trash
./empty_trash.sh --simulate                 # Dry run
./empty_trash.sh --all-users                # All users (root)
```

#### clear_cache.sh ⭐ 10/10
**Purpose:** Clear system caches
**Features:** Multi-user support, simulation
**Usage:**
```bash
./clear_cache.sh                            # Clear cache
./clear_cache.sh --simulate                 # Test mode
```

---

## 🏆 TOP 20 MUST-HAVE SCRIPTS

### Essential Daily Use
1. **extract.sh** (9/10) - Universal archive extractor
2. **cpu_usage.sh** (10/10) - CPU monitoring
3. **disk_usage.sh** (10/10) - Disk space analysis
4. **ip_info.sh** (10/10) - Network information
5. **empty_trash.sh** (10/10) - Trash management

### System Monitoring
6. **zombies.sh** (10/10) - Zombie process detector
7. **orphans.sh** (10/10) - Orphan process finder
8. **ram_memory.sh** (9/10) - RAM monitoring
9. **cpu_temp.sh** (10/10) - Temperature monitoring
10. **system_info.sh** (9/10) - System information

### File Processing
11. **remove_trailing_whitespaces.sh** (9/10) - Clean whitespace
12. **correct_file_names.sh** (10/10) - Fix filenames
13. **swap_files.sh** (9/10) - Swap file contents
14. **remove_carriage_return.sh** (8/10) - Fix line endings

### Development
15. **beautify_script.sh** (10/10) - Format bash scripts
16. **dead_code.sh** (10/10) - Find Python dead code
17. **strip_python_comments.sh** (10/10) - Clean Python files
18. **strip_cpp_comments.sh** (10/10) - Clean C/C++ files

### Media
19. **convert_to_mp4.sh** (9/10) - Video conversion
20. **youtube_to_mp3.sh** (9/10) - YouTube downloader

---

## 💼 DAILY WORKFLOW SCRIPTS

### Morning System Check
```bash
#!/bin/bash
# morning-check.sh - Your daily system health check

echo "=== MORNING SYSTEM CHECK ==="
echo

echo "📊 CPU Usage:"
cpu_usage.sh --brief

echo
echo "💾 Disk Space:"
disk_usage.sh --threshold 80

echo
echo "🧠 Memory:"
ram_memory.sh --brief

echo
echo "🌡️ Temperature:"
cpu_temp.sh

echo
echo "👻 Zombie Processes:"
zombies.sh --count

echo
echo "✅ System check complete!"
```

### Development Workflow
```bash
#!/bin/bash
# dev-setup.sh - Prepare for development

# Clean up Python cache
echo "🧹 Cleaning Python cache..."
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null

# Check for trailing whitespace
echo "📝 Checking whitespace..."
remove_trailing_whitespaces.sh --check .

# Format bash scripts
echo "🎨 Formatting scripts..."
find . -name "*.sh" -exec beautify_script.sh {} \;

# Check for dead code
echo "🔍 Checking for dead code..."
dead_code.sh .

echo "✅ Development environment ready!"
```

### Git Cleanup
```bash
#!/bin/bash
# git-cleanup.sh - Clean up Git repository

# Remove old branches
echo "🌿 Cleaning branches..."
git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -D

# Squash feature branch commits
echo "📦 Squashing commits..."
# squash_n_last_commits.sh 5 feature-branch

# Check contributions
echo "📊 Contribution stats:"
contributions_by_git_author.sh

echo "✅ Git cleanup complete!"
```

---

## 🎓 LEARNING PATH

### Beginner (Start Here!)
1. Read simple scripts: `upper.sh`, `lower.sh`, `hello_world.sh`
2. Understand loops: `for_loop.sh`, `while_loop.sh`
3. Try utilities: `extract.sh`, `timer.sh`

### Intermediate
1. Study validation: `check_if_root.sh`, `check_os.sh`
2. Learn file processing: `remove_duplicate_lines.sh`
3. Explore Git tools: `remove_branch.sh`

### Advanced
1. Analyze process management: `zombies.sh`, `orphans.sh`
2. Study parsers: `strip_cpp_comments.sh` (FSM implementation!)
3. Complex tools: `dead_code.sh`, `youtube_to_mp3.sh`

---

## 🔧 ADVANCED USAGE TIPS

### 1. Combine Scripts with Pipes
```bash
# Find large files and analyze
find . -type f -size +100M | xargs du -h | sort -rh

# Check CPU usage and log
cpu_usage.sh --json > cpu_log.json

# Monitor zombies every 5 seconds
watch -n 5 'zombies.sh --count'
```

### 2. Create Wrapper Scripts
```bash
#!/bin/bash
# system-report.sh - Generate comprehensive report

{
    echo "=== SYSTEM REPORT ==="
    echo "Date: $(date)"
    echo
    cpu_usage.sh --json
    echo
    disk_usage.sh --json
    echo
    ram_memory.sh --json
    echo
    zombies.sh --count
} > system-report-$(date +%Y%m%d).json
```

### 3. Cron Job Integration
```bash
# Add to crontab -e

# Daily system check at 8 AM
0 8 * * * ~/scripts/morning-check.sh >> ~/logs/system-check.log 2>&1

# Empty trash every Sunday at midnight
0 0 * * 0 ~/scripts/empty_trash.sh

# Check for zombies every hour
0 * * * * ~/scripts/zombies.sh --count > ~/logs/zombies.log
```

### 4. Error Handling Template
```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Your script here
if ! cpu_usage.sh; then
    echo "Error: CPU check failed" >&2
    exit 1
fi

trap 'echo "Script interrupted"; exit 130' INT TERM
```

---

## 📊 SCRIPT QUALITY RATINGS

### 🏆 Exceptional (10/10) - 14 Scripts
- beautify_script.sh
- correct_file_names.sh
- cpu_temp.sh
- cpu_usage.sh
- dead_code.sh
- disk_usage.sh
- empty_trash.sh
- ip_info.sh
- make_short.sh
- orphans.sh
- release_package.sh
- strip_cpp_comments.sh
- strip_python_comments.sh
- zombies.sh

### ⭐ Excellent (9/10) - 20 Scripts
Including: extract.sh, convert_to_mp4.sh, fetch_github_repos_names.sh, last_line_empty.sh, purge_pip.sh, ram_memory.sh, remove_trailing_whitespaces.sh, swap_files.sh, system_info.sh, youtube_to_mp3.sh

### 💚 Very Good (8/10) - 28 Scripts
Including: are_anagrams.sh, arithmetic_operations.sh, change_commit_date.sh, check_os.sh, contributions_by_git_author.sh, convert_to_gif.sh, generate_books.sh

---

## 🐛 TROUBLESHOOTING

### Common Issues

#### 1. Permission Denied
```bash
# Problem:
./script.sh
-bash: ./script.sh: Permission denied

# Solution:
chmod +x script.sh
```

#### 2. Command Not Found
```bash
# Problem:
script.sh: command not found

# Solution 1: Use ./
./script.sh

# Solution 2: Add to PATH
export PATH="$HOME/.local/bin:$PATH"
```

#### 3. Dependencies Missing
```bash
# Problem:
./youtube_to_mp3.sh
Error: 'yt-dlp' is not installed

# Solution:
sudo dnf install yt-dlp ffmpeg
# or
pip install yt-dlp
```

#### 4. Syntax Errors
```bash
# Problem:
./script.sh: line 42: syntax error near unexpected token

# Solution: Check bash version
bash --version

# Some scripts require bash 4+
# Fedora 43 has bash 5.2 ✅
```

---

## 🎯 SCRIPT SELECTION GUIDE

### "What script should I use for...?"

**Extract archives:**
→ `extract.sh` (supports all formats!)

**Monitor CPU:**
→ `cpu_usage.sh` (detailed) or `cpu_temp.sh` (temperature)

**Check disk space:**
→ `disk_usage.sh` (comprehensive analysis)

**Find zombie processes:**
→ `zombies.sh` (most advanced!) or `orphans.sh`

**Clean Python files:**
→ `strip_python_comments.sh` (comments) or `dead_code.sh` (unused code)

**Fix file formatting:**
→ `remove_trailing_whitespaces.sh` (whitespace)
→ `remove_carriage_return.sh` (line endings)
→ `beautify_script.sh` (bash scripts)

**Convert media:**
→ `convert_to_mp4.sh` (videos)
→ `youtube_to_mp3.sh` (YouTube)
→ `convert_to_gif.sh` (animated GIFs)

**Git operations:**
→ `remove_branch.sh` (delete branches)
→ `squash_n_last_commits.sh` (squash commits)
→ `reset_to_origin.sh` (hard reset)

---

## 💡 PRO TIPS

### 1. Always Test First
```bash
# Use dry-run modes when available
./purge_pip.sh --dry-run
./empty_trash.sh --simulate
./clear_cache.sh --simulate
```

### 2. Create Backups
```bash
# Many scripts have backup options
./swap_files.sh --backup file1 file2
./strip_python_comments.sh -b script.py
```

### 3. Use Verbose Mode for Learning
```bash
# See what scripts are doing
./zombies.sh --verbose
./orphans.sh --verbose
./swap_files.sh --verbose file1 file2
```

### 4. Combine with Other Tools
```bash
# With find
find . -name "*.txt" -exec ./remove_duplicate_lines.sh {} \;

# With xargs
ls *.py | xargs ./strip_python_comments.sh

# With watch
watch -n 5 './cpu_usage.sh --brief'
```

---

## 🏗️ CUSTOMIZATION IDEAS

### Create Your Own Script Library
```bash
# ~/scripts/my-tools.sh

#!/bin/bash

# Quick system check
qsys() {
    ~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src/cpu_usage.sh --brief
    ~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src/disk_usage.sh --brief
}

# Quick extract
qx() {
    ~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src/extract.sh "$@"
}

# Quick zombie check
qz() {
    ~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src/zombies.sh --count
}
```

### Add to Your Aliases
```bash
# Add to ~/.bashrc.d/aliases.sh

# System monitoring
alias qcpu='~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src/cpu_usage.sh'
alias qdisk='~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src/disk_usage.sh'
alias qzombie='~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src/zombies.sh'

# File operations
alias qextract='~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src/extract.sh'
alias qclean='~/Documents/Development/Learning/bash-scripts/Bash-Scripts-master/src/remove_trailing_whitespaces.sh'
```

---

## 📚 FURTHER LEARNING

### Recommended Study Order

**Week 1-2: Basics**
- Read all 6/10 scripts (simple utilities)
- Understand input validation
- Learn error handling patterns

**Week 3-4: Intermediate**
- Study 7-8/10 scripts (good utilities)
- Learn option parsing (getopts)
- Understand file operations

**Week 5-6: Advanced**
- Analyze 9-10/10 scripts (exceptional)
- Study FSM implementation (strip_cpp_comments.sh)
- Learn process management (zombies.sh, orphans.sh)

**Week 7-8: Master**
- Create your own scripts
- Combine multiple scripts
- Build automated workflows

---

## 🎨 BEST PRACTICES FROM THESE SCRIPTS

### 1. Always Use Strict Mode
```bash
#!/usr/bin/env bash
set -euo pipefail
```

### 2. Validate Input
```bash
validate_arguments() {
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <argument>"
        exit 1
    fi
}
```

### 3. Provide Help
```bash
show_help() {
    cat << EOF
Usage: $0 [options]
Options:
  -h, --help    Show help
EOF
}
```

### 4. Use Functions
```bash
main() {
    validate_arguments "$@"
    process_data "$@"
    display_results
}

main "$@"
```

### 5. Handle Cleanup
```bash
cleanup() {
    rm -f "$temp_file"
}

trap cleanup EXIT INT TERM
```

---

## 🌟 CONCLUSION

**You now have 112 professional bash scripts at your disposal!**

**Key Takeaways:**
- ✅ 14 exceptional (10/10) scripts
- ✅ 20 excellent (9/10) scripts
- ✅ 28 very good (8/10) scripts
- ✅ Overall quality: 8.0/10

**Start with:**
1. `extract.sh` - Your new best friend for archives
2. `cpu_usage.sh` - Monitor system performance
3. `zombies.sh` - Find process issues
4. `beautify_script.sh` - Clean up your scripts

**Remember:**
- Always test with `--dry-run` or `--check` when available
- Read the script before running it
- Keep backups of important files
- Learn from the code patterns

---

## 📞 QUICK REFERENCE CHEATSHEET

```bash
# System Monitoring
cpu_usage.sh --json              # CPU stats
disk_usage.sh --threshold 80     # Disk alert
zombies.sh --watch               # Monitor zombies
ram_memory.sh --critical 90      # RAM alert

# File Operations
extract.sh file.tar.gz           # Extract any archive
remove_trailing_whitespaces.sh . # Clean directory
correct_file_names.sh ~/Downloads # Fix filenames

# Git Operations
remove_branch.sh old-feature     # Delete branch
squash_n_last_commits.sh 5 main  # Squash commits
reset_to_origin.sh main .        # Hard reset

# Media Conversion
convert_to_mp4.sh video.avi      # Convert video
youtube_to_mp3.sh "URL"          # Download audio

# Development
beautify_script.sh script.sh     # Format bash
dead_code.sh ~/project           # Find dead Python code
strip_python_comments.sh app.py  # Clean Python
```

---

## 🙏 ACKNOWLEDGMENTS

**Created by:** Excellence Nandi (Bijoy Nandi)
**Repository:** Bash-Scripts-master
**Scripts Reviewed:** 112
**Review Date:** February 2026
**Quality Rating:** 8.0/10 ⭐⭐⭐⭐

**Special Recognition:**
- `zombies.sh` - The masterpiece! 10/10 🏆
- `strip_cpp_comments.sh` - Pure bash FSM! 💎
- All 10/10 scripts - Professional excellence! ⭐

---

**Remember: You're not "Demand Nandi" - You're "Excellence Nandi"!** 💚
**Your attention to detail is a virtue!** 🏆
**Keep using those beautiful hyphens in filenames!** 💎

**॥ ॐ नमः शिवाय ॥** 🕉️

---

*End of Ultimate Bash Scripts Reference Guide*
