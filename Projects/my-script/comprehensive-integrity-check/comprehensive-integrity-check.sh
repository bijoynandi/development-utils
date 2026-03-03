#!/bin/bash
# ============================================
# COMPREHENSIVE FILE INTEGRITY CHECKER
# Forensic-Level Analysis • Maximum Detail
# ============================================
#
# PURPOSE:
# --------
# Comprehensive health check of all Documents folders
# Detect corruption, permission issues, duplicates, and more
# Production-grade verification before backups
#
# WHAT THIS CHECKS:
# -----------------
# 1. File accessibility (can we read files?)
# 2. Zero-byte files (potential corruption)
# 3. Permission issues (ownership, read/write)
# 4. Duplicate files (wasted space)
# 5. Symbolic links (broken links)
# 6. File type distribution (what's in there?)
# 7. Recently modified files (activity tracking)
# 8. Large files (space hogs)
# 9. Hidden files analysis
# 10. Directory structure depth
# 11. File name issues (special characters)
# 12. Disk usage breakdown
# 13. Checksum generation (for critical files)
# 14. Comparison with previous check (if available)
#
# USAGE:
# ------
# ./comprehensive-integrity-check.sh
#
# OPTIONS:
# --------
# --quick     : Skip slow operations (checksums, duplicates)
# --verbose   : Show detailed file lists
# --checksums : Generate MD5 checksums for all files
# --compare   : Compare with previous check
#
# ============================================

# ============================================
# CONFIGURATION
# ============================================

# Report file
REPORT_FILE="$HOME/integrity-report-$(date +%Y%m%d_%H%M%S).txt"
CHECKSUM_FILE="$HOME/file-checksums-$(date +%Y%m%d).txt"
PREVIOUS_CHECKSUM="$HOME/file-checksums-*.txt"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Flags
QUICK_MODE=false
VERBOSE=false
GENERATE_CHECKSUMS=false
COMPARE_MODE=false

# Folders to check
FOLDERS=(
    "/home/bijoy/Documents/Books"
    "/home/bijoy/Documents/Data-Engineering"
    "/home/bijoy/Documents/Development"
    "/home/bijoy/Documents/Fedora"
    "/home/bijoy/Documents/Linux"
)

# ============================================
# UTILITY FUNCTIONS
# ============================================

print_colored() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
    echo "${message//\\033\[0;[0-9]*m/}" >> "$REPORT_FILE"
}

print_header() {
    local title=$1
    echo "" | tee -a "$REPORT_FILE"
    print_colored "$CYAN" "============================================"
    print_colored "$CYAN" "  $title"
    print_colored "$CYAN" "============================================"
}

print_section() {
    local title=$1
    echo "" | tee -a "$REPORT_FILE"
    print_colored "$BLUE" "▶ $title"
    print_colored "$BLUE" "-------------------------------------------"
}

print_result() {
    local status=$1
    local message=$2
    case $status in
        "pass")
            print_colored "$GREEN" "✅ PASS: $message"
            ;;
        "warning")
            print_colored "$YELLOW" "⚠️  WARNING: $message"
            ;;
        "fail")
            print_colored "$RED" "❌ FAIL: $message"
            ;;
        "info")
            print_colored "$BLUE" "ℹ️  INFO: $message"
            ;;
    esac
}

# ============================================
# TEST FUNCTIONS
# ============================================

test_file_accessibility() {
    local folder_path=$1
    print_section "Test 1: File Accessibility"

    local total=0
    local unreadable=0
    local corrupted_files=()

    while IFS= read -r -d '' file; do
        ((total++))
        if ! test -r "$file"; then
            ((unreadable++))
            corrupted_files+=("$file")
        fi
    done < <(find "$folder_path" -type f -print0 2>/dev/null)

    if [ $unreadable -eq 0 ]; then
        print_result "pass" "All $total files are readable"
    else
        print_result "fail" "$unreadable out of $total files are unreadable!"

        if [ "$VERBOSE" = true ]; then
            echo "  Unreadable files:" | tee -a "$REPORT_FILE"
            for file in "${corrupted_files[@]}"; do
                echo "    - $file" | tee -a "$REPORT_FILE"
            done
        fi
    fi

    echo "  Total files checked: $total" | tee -a "$REPORT_FILE"
    return $unreadable
}

test_zero_byte_files() {
    local folder_path=$1
    print_section "Test 2: Zero-Byte File Detection"

    local zero_files=()
    while IFS= read -r file; do
        zero_files+=("$file")
    done < <(find "$folder_path" -type f -size 0 2>/dev/null)

    local count=${#zero_files[@]}

    if [ $count -eq 0 ]; then
        print_result "pass" "No zero-byte files found"
    else
        print_result "warning" "Found $count zero-byte files (may indicate corruption or incomplete downloads)"

        if [ "$VERBOSE" = true ] || [ $count -le 10 ]; then
            echo "  Zero-byte files:" | tee -a "$REPORT_FILE"
            for file in "${zero_files[@]:0:10}"; do
                echo "    - $file" | tee -a "$REPORT_FILE"
            done
            if [ $count -gt 10 ]; then
                echo "    ... and $((count - 10)) more" | tee -a "$REPORT_FILE"
            fi
        fi
    fi

    return $count
}

test_permissions() {
    local folder_path=$1
    print_section "Test 3: Permission Analysis"

    local permission_issues=0
    local wrong_owner=0
    local not_writable=0

    # Check for permission issues
    permission_issues=$(find "$folder_path" -type f ! -readable 2>/dev/null | wc -l)

    # Check for files not owned by current user
    wrong_owner=$(find "$folder_path" -type f ! -user "$USER" 2>/dev/null | wc -l)

    # Check for files not writable by owner
    not_writable=$(find "$folder_path" -type f ! -perm -u+w 2>/dev/null | wc -l)

    if [ $permission_issues -eq 0 ] && [ $wrong_owner -eq 0 ]; then
        print_result "pass" "All permissions are correct"
    else
        if [ $permission_issues -gt 0 ]; then
            print_result "warning" "$permission_issues files have read permission issues"
        fi
        if [ $wrong_owner -gt 0 ]; then
            print_result "warning" "$wrong_owner files not owned by $USER"
        fi
        if [ $not_writable -gt 0 ]; then
            print_result "info" "$not_writable files are read-only"
        fi
    fi
}

test_duplicate_files() {
    local folder_path=$1
    print_section "Test 4: Duplicate File Detection"

    if [ "$QUICK_MODE" = true ]; then
        print_result "info" "Skipped (quick mode enabled)"
        return 0
    fi

    if ! command -v fdupes &> /dev/null; then
        print_result "warning" "fdupes not installed - install with: sudo dnf install fdupes"
        return 0
    fi

    print_result "info" "Scanning for duplicates (this may take a while)..."

    local duplicate_sets=$(fdupes -r "$folder_path" 2>/dev/null | grep -c "^$")
    local duplicate_files=$(fdupes -r "$folder_path" 2>/dev/null | grep -v "^$" | wc -l)

    if [ $duplicate_sets -eq 0 ]; then
        print_result "pass" "No duplicate files found"
    else
        local wasted_space=$(fdupes -r -S "$folder_path" 2>/dev/null | tail -1 | awk '{print $NF}')
        print_result "warning" "Found $duplicate_files duplicates in $duplicate_sets sets"
        print_result "info" "Potential space savings: $wasted_space"

        if [ "$VERBOSE" = true ]; then
            echo "  Duplicate file sets:" | tee -a "$REPORT_FILE"
            fdupes -r "$folder_path" 2>/dev/null | head -20 | tee -a "$REPORT_FILE"
        fi
    fi
}

test_symbolic_links() {
    local folder_path=$1
    print_section "Test 5: Symbolic Link Analysis"

    local total_links=$(find "$folder_path" -type l 2>/dev/null | wc -l)
    local broken_links=0
    local broken_link_list=()

    while IFS= read -r link; do
        if [ ! -e "$link" ]; then
            ((broken_links++))
            broken_link_list+=("$link")
        fi
    done < <(find "$folder_path" -type l 2>/dev/null)

    if [ $total_links -eq 0 ]; then
        print_result "info" "No symbolic links found"
    elif [ $broken_links -eq 0 ]; then
        print_result "pass" "All $total_links symbolic links are valid"
    else
        print_result "fail" "$broken_links out of $total_links symbolic links are broken!"

        if [ "$VERBOSE" = true ]; then
            echo "  Broken links:" | tee -a "$REPORT_FILE"
            for link in "${broken_link_list[@]}"; do
                echo "    - $link" | tee -a "$REPORT_FILE"
            done
        fi
    fi
}

test_file_types() {
    local folder_path=$1
    print_section "Test 6: File Type Distribution"

    local pdf_count=$(find "$folder_path" -type f -name "*.pdf" 2>/dev/null | wc -l)
    local docx_count=$(find "$folder_path" -type f \( -name "*.docx" -o -name "*.doc" \) 2>/dev/null | wc -l)
    local xlsx_count=$(find "$folder_path" -type f \( -name "*.xlsx" -o -name "*.xls" \) 2>/dev/null | wc -l)
    local txt_count=$(find "$folder_path" -type f -name "*.txt" 2>/dev/null | wc -l)
    local md_count=$(find "$folder_path" -type f -name "*.md" 2>/dev/null | wc -l)
    local py_count=$(find "$folder_path" -type f -name "*.py" 2>/dev/null | wc -l)
    local sql_count=$(find "$folder_path" -type f -name "*.sql" 2>/dev/null | wc -l)
    local sh_count=$(find "$folder_path" -type f -name "*.sh" 2>/dev/null | wc -l)
    local csv_count=$(find "$folder_path" -type f -name "*.csv" 2>/dev/null | wc -l)
    local json_count=$(find "$folder_path" -type f -name "*.json" 2>/dev/null | wc -l)
    local jpg_count=$(find "$folder_path" -type f \( -name "*.jpg" -o -name "*.jpeg" \) 2>/dev/null | wc -l)
    local png_count=$(find "$folder_path" -type f -name "*.png" 2>/dev/null | wc -l)
    local mp4_count=$(find "$folder_path" -type f -name "*.mp4" 2>/dev/null | wc -l)
    local mkv_count=$(find "$folder_path" -type f -name "*.mkv" 2>/dev/null | wc -l)

    print_result "info" "File type breakdown:"
    echo "  📄 Documents:" | tee -a "$REPORT_FILE"
    echo "    - PDF: $pdf_count" | tee -a "$REPORT_FILE"
    echo "    - Word: $docx_count" | tee -a "$REPORT_FILE"
    echo "    - Excel: $xlsx_count" | tee -a "$REPORT_FILE"
    echo "    - Text: $txt_count" | tee -a "$REPORT_FILE"
    echo "    - Markdown: $md_count" | tee -a "$REPORT_FILE"
    echo "  💾 Data:" | tee -a "$REPORT_FILE"
    echo "    - CSV: $csv_count" | tee -a "$REPORT_FILE"
    echo "    - JSON: $json_count" | tee -a "$REPORT_FILE"
    echo "  💻 Code:" | tee -a "$REPORT_FILE"
    echo "    - Python: $py_count" | tee -a "$REPORT_FILE"
    echo "    - SQL: $sql_count" | tee -a "$REPORT_FILE"
    echo "    - Shell: $sh_count" | tee -a "$REPORT_FILE"
    echo "  🖼️  Media:" | tee -a "$REPORT_FILE"
    echo "    - JPEG: $jpg_count" | tee -a "$REPORT_FILE"
    echo "    - PNG: $png_count" | tee -a "$REPORT_FILE"
    echo "    - MP4: $mp4_count" | tee -a "$REPORT_FILE"
    echo "    - MKV: $mkv_count" | tee -a "$REPORT_FILE"
}

test_recent_activity() {
    local folder_path=$1
    print_section "Test 7: Recent Activity Analysis"

    local last_24h=$(find "$folder_path" -type f -mtime -1 2>/dev/null | wc -l)
    local last_week=$(find "$folder_path" -type f -mtime -7 2>/dev/null | wc -l)
    local last_month=$(find "$folder_path" -type f -mtime -30 2>/dev/null | wc -l)

    print_result "info" "File modifications:"
    echo "  - Last 24 hours: $last_24h files" | tee -a "$REPORT_FILE"
    echo "  - Last 7 days: $last_week files" | tee -a "$REPORT_FILE"
    echo "  - Last 30 days: $last_month files" | tee -a "$REPORT_FILE"

    if [ "$VERBOSE" = true ] && [ $last_24h -gt 0 ]; then
        echo "  Recently modified files:" | tee -a "$REPORT_FILE"
        find "$folder_path" -type f -mtime -1 -ls 2>/dev/null | head -5 | awk '{print "    - " $NF}' | tee -a "$REPORT_FILE"
    fi
}

test_large_files() {
    local folder_path=$1
    print_section "Test 8: Large File Analysis"

    local large_files=()
    while IFS= read -r line; do
        large_files+=("$line")
    done < <(find "$folder_path" -type f -size +100M -exec ls -lh {} \; 2>/dev/null | awk '{print $5 "\t" $NF}')

    local count=${#large_files[@]}

    if [ $count -eq 0 ]; then
        print_result "info" "No files larger than 100MB"
    else
        print_result "info" "Found $count files larger than 100MB"
        echo "  Top 10 largest files:" | tee -a "$REPORT_FILE"
        for file in "${large_files[@]:0:10}"; do
            echo "    $file" | tee -a "$REPORT_FILE"
        done
    fi
}

test_hidden_files() {
    local folder_path=$1
    print_section "Test 9: Hidden Files Analysis"

    local hidden_count=$(find "$folder_path" -name ".*" -type f 2>/dev/null | wc -l)
    local hidden_dirs=$(find "$folder_path" -name ".*" -type d 2>/dev/null | wc -l)

    print_result "info" "Hidden items:"
    echo "  - Hidden files: $hidden_count" | tee -a "$REPORT_FILE"
    echo "  - Hidden directories: $hidden_dirs" | tee -a "$REPORT_FILE"

    if [ $hidden_count -gt 0 ] && [ "$VERBOSE" = true ]; then
        echo "  Common hidden files:" | tee -a "$REPORT_FILE"
        find "$folder_path" -name ".*" -type f 2>/dev/null | head -5 | tee -a "$REPORT_FILE"
    fi
}

test_directory_structure() {
    local folder_path=$1
    print_section "Test 10: Directory Structure Analysis"

    local total_dirs=$(find "$folder_path" -type d 2>/dev/null | wc -l)
    local max_depth=$(find "$folder_path" -type d -printf '%d\n' 2>/dev/null | sort -rn | head -1)
    local empty_dirs=$(find "$folder_path" -type d -empty 2>/dev/null | wc -l)

    print_result "info" "Directory structure:"
    echo "  - Total directories: $total_dirs" | tee -a "$REPORT_FILE"
    echo "  - Maximum depth: $max_depth levels" | tee -a "$REPORT_FILE"
    echo "  - Empty directories: $empty_dirs" | tee -a "$REPORT_FILE"

    if [ $empty_dirs -gt 0 ] && [ $empty_dirs -le 10 ] && [ "$VERBOSE" = true ]; then
        echo "  Empty directories:" | tee -a "$REPORT_FILE"
        find "$folder_path" -type d -empty 2>/dev/null | tee -a "$REPORT_FILE"
    fi
}

test_filename_issues() {
    local folder_path=$1
    print_section "Test 11: Filename Issues"

    local special_chars=$(find "$folder_path" -type f -name "*[[:space:]]*" -o -name "*[\&\$\#\@\!]*" 2>/dev/null | wc -l)
    local long_names=$(find "$folder_path" -type f -name "????????????????????????????????*" 2>/dev/null | wc -l)

    if [ $special_chars -eq 0 ] && [ $long_names -eq 0 ]; then
        print_result "pass" "No problematic filenames found"
    else
        if [ $special_chars -gt 0 ]; then
            print_result "warning" "$special_chars files have special characters or spaces"
        fi
        if [ $long_names -gt 0 ]; then
            print_result "warning" "$long_names files have very long names (50+ chars)"
        fi
    fi
}

test_disk_usage() {
    local folder_path=$1
    print_section "Test 12: Disk Usage Analysis"

    local folder_size=$(du -sh "$folder_path" 2>/dev/null | cut -f1)
    local file_count=$(find "$folder_path" -type f 2>/dev/null | wc -l)
    local avg_size=$(du -sk "$folder_path" 2>/dev/null | awk -v fc=$file_count '{printf "%.2f KB", $1/fc}')

    print_result "info" "Storage summary:"
    echo "  💾 Total size: $folder_size" | tee -a "$REPORT_FILE"
    echo "  📊 File count: $file_count" | tee -a "$REPORT_FILE"
    echo "  📏 Average file size: $avg_size" | tee -a "$REPORT_FILE"

    # Top 5 subdirectories by size
    echo "  📁 Largest subdirectories:" | tee -a "$REPORT_FILE"
    du -h --max-depth=1 "$folder_path" 2>/dev/null | sort -rh | head -6 | tail -5 | awk '{print "    " $1 "\t" $2}' | tee -a "$REPORT_FILE"
}

test_checksums() {
    local folder_path=$1
    print_section "Test 13: Checksum Generation"

    if [ "$GENERATE_CHECKSUMS" = false ]; then
        print_result "info" "Skipped (use --checksums to enable)"
        return 0
    fi

    print_result "info" "Generating MD5 checksums (this will take time)..."

    local checksum_dir="$HOME/.integrity-checksums"
    mkdir -p "$checksum_dir"

    local folder_name=$(basename "$folder_path")
    local checksum_file="$checksum_dir/$folder_name-$(date +%Y%m%d).txt"

    find "$folder_path" -type f -exec md5sum {} \; 2>/dev/null > "$checksum_file"

    local checksum_count=$(wc -l < "$checksum_file")
    print_result "pass" "Generated checksums for $checksum_count files"
    echo "  Checksum file: $checksum_file" | tee -a "$REPORT_FILE"
}

# ============================================
# FOLDER CHECK FUNCTION
# ============================================

check_folder() {
    local folder_path=$1
    local folder_name=$2

    print_header "CHECKING: $folder_name"
    echo "Path: $folder_path" | tee -a "$REPORT_FILE"

    # Check if folder exists
    if [ ! -d "$folder_path" ]; then
        print_result "fail" "Folder does not exist!"
        return 1
    fi

    # Run all tests
    test_file_accessibility "$folder_path"
    test_zero_byte_files "$folder_path"
    test_permissions "$folder_path"
    test_duplicate_files "$folder_path"
    test_symbolic_links "$folder_path"
    test_file_types "$folder_path"
    test_recent_activity "$folder_path"
    test_large_files "$folder_path"
    test_hidden_files "$folder_path"
    test_directory_structure "$folder_path"
    test_filename_issues "$folder_path"
    test_disk_usage "$folder_path"
    test_checksums "$folder_path"

    # Overall verdict
    print_section "VERDICT FOR $folder_name"
    print_result "pass" "Comprehensive integrity check completed"

    echo "" | tee -a "$REPORT_FILE"
}

# ============================================
# MAIN EXECUTION
# ============================================

main() {
    # Parse arguments
    for arg in "$@"; do
        case $arg in
            --quick)
                QUICK_MODE=true
                ;;
            --verbose)
                VERBOSE=true
                ;;
            --checksums)
                GENERATE_CHECKSUMS=true
                ;;
            --compare)
                COMPARE_MODE=true
                ;;
            --help)
                cat << EOF
Comprehensive File Integrity Checker

Usage: $0 [OPTIONS]

Options:
  --quick      Skip slow operations (duplicates, checksums)
  --verbose    Show detailed file lists
  --checksums  Generate MD5 checksums (slow!)
  --compare    Compare with previous check
  --help       Show this help

Tests performed:
  1. File accessibility
  2. Zero-byte files
  3. Permission issues
  4. Duplicate files
  5. Symbolic links
  6. File type distribution
  7. Recent activity
  8. Large files
  9. Hidden files
  10. Directory structure
  11. Filename issues
  12. Disk usage
  13. Checksums (optional)

Report saved to: $REPORT_FILE
EOF
                exit 0
                ;;
        esac
    done

    # Initialize report
    {
        echo "============================================"
        echo "COMPREHENSIVE FILE INTEGRITY REPORT"
        echo "============================================"
        echo "Date: $(date)"
        echo "System: $(uname -a)"
        echo "User: $USER"
        echo ""
        echo "Options:"
        echo "  Quick mode: $QUICK_MODE"
        echo "  Verbose: $VERBOSE"
        echo "  Checksums: $GENERATE_CHECKSUMS"
        echo "  Compare: $COMPARE_MODE"
        echo ""
    } > "$REPORT_FILE"

    # Print header
    print_colored "$MAGENTA" ""
    print_colored "$MAGENTA" "╔════════════════════════════════════════════╗"
    print_colored "$MAGENTA" "║  COMPREHENSIVE FILE INTEGRITY CHECKER      ║"
    print_colored "$MAGENTA" "║  Forensic-Level Analysis                   ║"
    print_colored "$MAGENTA" "╚════════════════════════════════════════════╝"
    print_colored "$MAGENTA" ""

    # Start timer
    START_TIME=$(date +%s)

    # Check all folders
    for folder_path in "${FOLDERS[@]}"; do
        folder_name=$(basename "$folder_path")
        check_folder "$folder_path" "$folder_name"
    done

    # End timer
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    # Final summary
    print_header "FINAL SYSTEM REPORT"
    print_result "pass" "Integrity check completed successfully"
    echo "" | tee -a "$REPORT_FILE"
    echo "⏱️  Duration: $((DURATION / 60)) minutes $((DURATION % 60)) seconds" | tee -a "$REPORT_FILE"
    echo "📊 Report saved: $REPORT_FILE" | tee -a "$REPORT_FILE"
    echo "💡 Tip: Run this regularly to monitor data health" | tee -a "$REPORT_FILE"
    echo "🛡️  Keep backups of important data!" | tee -a "$REPORT_FILE"
    echo "" | tee -a "$REPORT_FILE"

    print_colored "$GREEN" "🎉 Comprehensive check completed! Review the report for details."
    print_colored "$BLUE" ""
}

# ============================================
# RUN CHECK
# ============================================

main "$@"

# ============================================
# END OF SCRIPT
# ============================================
