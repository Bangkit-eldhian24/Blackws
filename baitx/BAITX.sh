#!/bin/bash

# BAITX - BlackArch Installer Tools eXtended
# Enhanced with complete tool tracking and logging system
# Author: Bangkiteldhian as ardx

# Color Definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
MAGENTA='\033[0;35m'
ORANGE='\033[0;33m'
NC='\033[0m'

# Logging Configuration
LOG_DIR="$HOME/baitx/checkup"
LOG_FILE="$LOG_DIR/checkbaitx.txt"
INSTALLED_PKGS_FILE="$LOG_DIR/installed_packages.txt"
FAILED_PKGS_FILE="$LOG_DIR/failed_packages.txt"
SESSION_LOG_DIR="$LOG_DIR/session_logs"
BACKUP_DIR="$HOME/baitx/backups"

# Session tracking
SESSION_ID=""
SESSION_START_TIME=""
CURRENT_CATEGORY=""

# BlackArch Categories
declare -a CATEGORIES=(
    "blackarch-webapp"
    "blackarch-fuzzer"
    "blackarch-scanner"
    "blackarch-proxy"
    "blackarch-windows"
    "blackarch-dos"
    "blackarch-disassembler"
    "blackarch-sniffer"
    "blackarch-voip"
    "blackarch-fingerprint"
    "blackarch-networking"
    "blackarch-recon"
    "blackarch-cracker"
    "blackarch-exploitation"
    "blackarch-spoof"
    "blackarch-ai"
    "blackarch-defensive"
    "blackarch-forensic"
    "blackarch-crypto"
    "blackarch-backdoor"
    "blackarch-wireless"
    "blackarch-automation"
    "blackarch-radio"
    "blackarch-binary"
    "blackarch-packer"
    "blackarch-reversing"
    "blackarch-mobile"
    "blackarch-malware"
    "blackarch-code-audit"
    "blackarch-social"
    "blackarch-honeypot"
    "blackarch-misc"
    "blackarch-wordlist"
    "blackarch-decompiler"
    "blackarch-config"
    "blackarch-debugger"
    "blackarch-bluetooth"
    "blackarch-database"
    "blackarch-automobile"
    "blackarch-hardware"
    "blackarch-nfc"
    "blackarch-tunnel"
    "blackarch-drone"
    "blackarch-unpacker"
    "blackarch-firmware"
    "blackarch-keylogger"
    "blackarch-stego"
    "blackarch-anti-forensic"
    "blackarch-ids"
    "blackarch-threat-model"
    "blackarch-gpu"
)

# ============================================================================
# LOGGING SYSTEM FUNCTIONS
# ============================================================================

# Initialize logging environment
init_logging() {
    # Create directory structure
    mkdir -p "$LOG_DIR" "$SESSION_LOG_DIR" "$BACKUP_DIR" 2>/dev/null
    
    # Generate session ID
    SESSION_ID="$(date +%Y%m%d_%H%M%S)_$$"
    SESSION_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Initialize main log file if it doesn't exist
    if [ ! -f "$LOG_FILE" ]; then
        {
            echo "================================================================================"
            echo "BAITX INSTALLATION LOG"
            echo "================================================================================"
            echo "System: $(hostname)"
            echo "User: $(whoami)"
            echo "Started: $SESSION_START_TIME"
            echo "Log File: $LOG_FILE"
            echo "================================================================================"
            echo ""
        } > "$LOG_FILE"
    fi
    
    # Initialize installed packages file
    if [ ! -f "$INSTALLED_PKGS_FILE" ]; then
        touch "$INSTALLED_PKGS_FILE"
    fi
    
    # Initialize failed packages file
    if [ ! -f "$FAILED_PKGS_FILE" ]; then
        touch "$FAILED_PKGS_FILE"
    fi
    
    # Create session log
    local session_log="$SESSION_LOG_DIR/session_${SESSION_ID}.log"
    {
        echo "Session ID: $SESSION_ID"
        echo "Started: $SESSION_START_TIME"
        echo "Command: $0 $*"
        echo "================================================"
    } > "$session_log"
    
    log_entry "SYSTEM" "Logging initialized | Session: $SESSION_ID"
}

# Write entry to main log file
log_entry() {
    local tag="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$tag] $message" >> "$LOG_FILE"
    
    # Also write to session log
    local session_log="$SESSION_LOG_DIR/session_${SESSION_ID}.log"
    echo "[$timestamp] [$tag] $message" >> "$session_log"
}

# Record successful installation
record_installation() {
    local pkg="$1"
    local category="$2"
    local version="$3"
    local size="$4"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log to main log
    log_entry "INSTALLED" "$pkg | Category: $category | Version: $version | Size: $size"
    
    # Add to installed packages index
    echo "$pkg|$category|$timestamp|$version|$size" >> "$INSTALLED_PKGS_FILE"
    
    # Remove from failed packages if exists
    if [ -f "$FAILED_PKGS_FILE" ]; then
        sed -i "/^$pkg|/d" "$FAILED_PKGS_FILE" 2>/dev/null
    fi
}

# Record failed installation
record_failure() {
    local pkg="$1"
    local category="$2"
    local error_msg="$3"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log to main log
    log_entry "FAILED" "$pkg | Category: $category | Error: $error_msg"
    
    # Add to failed packages
    echo "$pkg|$category|$timestamp|$error_msg" >> "$FAILED_PKGS_FILE"
}

# Record skipped package
record_skip() {
    local pkg="$1"
    local reason="$2"
    
    log_entry "SKIPPED" "$pkg | Reason: $reason"
}

# Record package dependencies
record_dependencies() {
    local pkg="$1"
    local deps="$2"
    
    log_entry "DEPS" "$pkg | Dependencies: $deps"
}

# Start category installation
start_category() {
    local category="$1"
    CURRENT_CATEGORY="$category"
    
    log_entry "CATEGORY" "Starting installation: $category"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}[*] Processing category: ${WHITE}$category${NC}"
}

# End category installation
end_category() {
    local category="$1"
    local total="$2"
    local installed="$3"
    local failed="$4"
    local skipped="$5"
    
    log_entry "CATEGORY_SUMMARY" "$category | Total: $total | Installed: $installed | Failed: $failed | Skipped: $skipped"
    
    echo -e "${GREEN}  Summary: $installed/$total installed${NC}"
    if [ "$failed" -gt 0 ]; then
        echo -e "${RED}  Failed: $failed${NC}"
    fi
    if [ "$skipped" -gt 0 ]; then
        echo -e "${YELLOW}  Skipped: $skipped${NC}"
    fi
}

# Record session summary
record_session_summary() {
    local total_attempted="$1"
    local total_installed="$2"
    local total_failed="$3"
    local total_skipped="$4"
    local duration="$5"
    
    log_entry "SESSION_SUMMARY" "Session: $SESSION_ID | Attempted: $total_attempted | Installed: $total_installed | Failed: $total_failed | Skipped: $total_skipped | Duration: $duration"
    
    {
        echo ""
        echo "================================================================================"
        echo "SESSION SUMMARY: $SESSION_ID"
        echo "================================================================================"
        echo "Started: $SESSION_START_TIME"
        echo "Ended: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Duration: $duration"
        echo "Total Attempted: $total_attempted"
        echo "Successfully Installed: $total_installed"
        echo "Failed: $total_failed"
        echo "Skipped: $total_skipped"
        echo "================================================================================"
        echo ""
    } >> "$LOG_FILE"
}

# ============================================================================
# SYSTEM STATE FUNCTIONS
# ============================================================================

# Backup system state before installation
backup_system_state() {
    local backup_file="$BACKUP_DIR/pre_install_state_${SESSION_ID}.txt"
    
    log_entry "BACKUP" "Creating system state backup: $backup_file"
    
    {
        echo "Backup created: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Session: $SESSION_ID"
        echo "================================================"
        echo "INSTALLED PACKAGES:"
        pacman -Qq | sort
    } > "$backup_file"
    
    echo -e "${GREEN}[+] System state backed up${NC}"
}

# Get package info
get_package_info() {
    local pkg="$1"
    
    local version=$(pacman -Q "$pkg" 2>/dev/null | awk '{print $2}')
    local size=$(pacman -Qi "$pkg" 2>/dev/null | grep "Installed Size" | awk -F': ' '{print $2}' | tr -d ' ')
    
    echo "$version|$size"
}

# ============================================================================
# UNINSTALL FUNCTIONS
# ============================================================================

# Get installed packages from log by category
get_installed_by_category() {
    local category="$1"
    
    if [ -f "$INSTALLED_PKGS_FILE" ]; then
        grep "|$category|" "$INSTALLED_PKGS_FILE" | cut -d'|' -f1 | sort -u
    fi
}

# Get installed packages from log by date range
get_installed_by_date() {
    local start_date="$1"
    local end_date="$2"
    
    if [ -f "$INSTALLED_PKGS_FILE" ]; then
        while IFS='|' read -r pkg category timestamp version size; do
            local pkg_date=$(echo "$timestamp" | cut -d' ' -f1)
            if [[ "$pkg_date" > "$start_date" || "$pkg_date" == "$start_date" ]] && [[ "$pkg_date" < "$end_date" || "$pkg_date" == "$end_date" ]]; then
                echo "$pkg"
            fi
        done < "$INSTALLED_PKGS_FILE" | sort -u
    fi
}

# Get all logged installed packages
get_all_logged_packages() {
    if [ -f "$INSTALLED_PKGS_FILE" ]; then
        cut -d'|' -f1 "$INSTALLED_PKGS_FILE" | sort -u
    fi
}

# Uninstall packages by category
uninstall_by_category() {
    local category="$1"
    
    echo -e "${YELLOW}[*] Retrieving packages for category: $category${NC}"
    
    local packages=($(get_installed_by_category "$category"))
    local count=${#packages[@]}
    
    if [ "$count" -eq 0 ]; then
        echo -e "${YELLOW}[!] No packages found for category: $category${NC}"
        return 1
    fi
    
    echo -e "${BLUE}[*] Found $count packages to uninstall${NC}"
    echo -e "${CYAN}Packages:${NC}"
    printf '  %s\n' "${packages[@]}"
    echo ""
    
    read -p "Proceed with uninstallation? [y/N]: " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Cancelled.${NC}"
        return 1
    fi
    
    log_entry "UNINSTALL" "Starting batch uninstall for category: $category | Packages: $count"
    
    local uninstalled=0
    local failed=0
    
    for pkg in "${packages[@]}"; do
        echo -e "${YELLOW}[*] Uninstalling: $pkg${NC}"
        
        if sudo pacman -R "$pkg" --noconfirm 2>/dev/null; then
            log_entry "UNINSTALLED" "$pkg | Category: $category | Reason: user_request"
            
            # Remove from installed packages file
            sed -i "/^$pkg|/d" "$INSTALLED_PKGS_FILE" 2>/dev/null
            
            echo -e "${GREEN}  ✓ Uninstalled: $pkg${NC}"
            ((uninstalled++))
        else
            log_entry "UNINSTALL_FAILED" "$pkg | Category: $category"
            echo -e "${RED}  ✗ Failed to uninstall: $pkg${NC}"
            ((failed++))
        fi
    done
    
    echo ""
    echo -e "${GREEN}[+] Uninstallation complete: $uninstalled succeeded, $failed failed${NC}"
    log_entry "UNINSTALL_SUMMARY" "Category: $category | Uninstalled: $uninstalled | Failed: $failed"
}

# Uninstall packages by date range
uninstall_by_date() {
    local start_date="$1"
    local end_date="$2"
    
    echo -e "${YELLOW}[*] Retrieving packages installed between $start_date and $end_date${NC}"
    
    local packages=($(get_installed_by_date "$start_date" "$end_date"))
    local count=${#packages[@]}
    
    if [ "$count" -eq 0 ]; then
        echo -e "${YELLOW}[!] No packages found in date range${NC}"
        return 1
    fi
    
    echo -e "${BLUE}[*] Found $count packages to uninstall${NC}"
    echo ""
    
    read -p "Proceed with uninstallation? [y/N]: " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Cancelled.${NC}"
        return 1
    fi
    
    log_entry "UNINSTALL" "Starting date-range uninstall | From: $start_date | To: $end_date | Packages: $count"
    
    local uninstalled=0
    for pkg in "${packages[@]}"; do
        if sudo pacman -R "$pkg" --noconfirm 2>/dev/null; then
            log_entry "UNINSTALLED" "$pkg | DateRange: $start_date to $end_date"
            sed -i "/^$pkg|/d" "$INSTALLED_PKGS_FILE" 2>/dev/null
            ((uninstalled++))
        fi
    done
    
    echo -e "${GREEN}[+] Uninstalled $uninstalled packages${NC}"
}

# ============================================================================
# REPORTING FUNCTIONS
# ============================================================================

# Generate comprehensive report
generate_report() {
    echo -e "${WHITE}              BAITX INSTALLATION REPORT${NC}"
    echo ""
    
    if [ ! -f "$LOG_FILE" ]; then
        echo -e "${RED}[!] No log file found${NC}"
        return 1
    fi
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Log File:${NC} $LOG_FILE"
    echo -e "${YELLOW}Log Size:${NC} $(du -h "$LOG_FILE" 2>/dev/null | cut -f1)"
    echo ""
    
    # Count statistics
    local total_installed=$(grep -c "\[INSTALLED\]" "$LOG_FILE" 2>/dev/null)
    local total_failed=$(grep -c "\[FAILED\]" "$LOG_FILE" 2>/dev/null)
    local total_skipped=$(grep -c "\[SKIPPED\]" "$LOG_FILE" 2>/dev/null)
    local total_uninstalled=$(grep -c "\[UNINSTALLED\]" "$LOG_FILE" 2>/dev/null)
    
    echo -e "${GREEN}Total Installed:${NC}   $total_installed"
    echo -e "${RED}Total Failed:${NC}      $total_failed"
    echo -e "${YELLOW}Total Skipped:${NC}     $total_skipped"
    echo -e "${MAGENTA}Total Uninstalled:${NC} $total_uninstalled"
    echo ""
    
    # Category breakdown
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}Installation by Category:${NC}"
    echo ""
    
    for category in "${CATEGORIES[@]}"; do
        local cat_count=$(grep "Category: $category" "$LOG_FILE" 2>/dev/null | wc -l)
        if [ "$cat_count" -gt 0 ]; then
            printf "${GREEN}%-30s${NC} : ${WHITE}%4d${NC} packages\n" "$category" "$cat_count"
        fi
    done
    
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    
    # Recent activity
    echo -e "${WHITE}Recent Activity (Last 10):${NC}"
    echo ""
    tail -n 10 "$LOG_FILE" 2>/dev/null | while read line; do
        echo "  $line"
    done
    
    echo ""
    
    # Save report to file
    local report_file="$LOG_DIR/report_$(date +%Y%m%d_%H%M%S).txt"
    {
        echo "BAITX INSTALLATION REPORT"
        echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "================================================"
        echo "Total Installed: $total_installed"
        echo "Total Failed: $total_failed"
        echo "Total Skipped: $total_skipped"
        echo "Total Uninstalled: $total_uninstalled"
        echo ""
        echo "INSTALLED PACKAGES INDEX:"
        cat "$INSTALLED_PKGS_FILE" 2>/dev/null
    } > "$report_file"
    
    echo -e "${GREEN}[+] Report saved to: $report_file${NC}"
}

# View log file
view_log() {
    if [ -f "$LOG_FILE" ]; then
        echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${WHITE}Viewing Log File: $LOG_FILE${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
        echo ""
        cat "$LOG_FILE"
    else
        echo -e "${RED}[!] Log file not found${NC}"
    fi
}

# Search log
search_log() {
    local keyword="$1"
    
    if [ -f "$LOG_FILE" ]; then
        echo -e "${YELLOW}[*] Searching for: $keyword${NC}"
        echo ""
        grep -i "$keyword" "$LOG_FILE" 2>/dev/null | while read line; do
            echo "  $line"
        done
    else
        echo -e "${RED}[!] Log file not found${NC}"
    fi
}

# ============================================================================
# DISPLAY FUNCTIONS
# ============================================================================

# ASCII Art Banner
show_banner() {
    echo -e "${WHITE}  ▄▄▄▄    ▄▄▄       ██▓▄▄▄█████▓${RED}▒██   ██▒${NC}"
    echo -e "${WHITE}▓█████▄ ▒████▄    ▓██▒▓  ██▒ ▓▒${RED}▒▒ █ █ ▒░${NC}"
    echo -e "${WHITE}▒██▒ ▄██▒██  ▀█▄  ▒██▒▒ ▓██░ ▒░${RED}░░  █   ░${NC}"
    echo -e "${WHITE}▒██░█▀  ░██▄▄▄▄██ ░██░░ ▓██▓ ░ ${RED} ░ █ █ ▒ ${NC}"
    echo -e "${WHITE}░▓█  ▀█▓ ▓█   ▓██▒░██░  ▒██▒ ░ ${RED}▒██▒ ▒██▒${NC}"
    echo -e "${WHITE}░▒▓███▀▒ ▒▒   ▓▒█░░▓    ▒ ░░   ${RED}▒▒ ░ ░▓ ░${NC}"
    echo -e "${WHITE}▒░▒   ░   ▒   ▒▒ ░ ▒ ░    ░    ${RED}░░   ░▒ ░${NC}"
    echo -e "${WHITE} ░    ░   ░   ▒    ▒ ░  ░       ${RED}░    ░  ${NC}"
    echo -e "${WHITE} ░            ░  ░ ░            ${RED}░    ░  ${NC}"
    echo -e "${WHITE}      ░                                 ${NC}"
    echo ""
    echo -e "${GREEN}[info]${NC} ${WHITE}blackarch installer tools eXtended${NC}, ${RED}with logging${NC}"
    echo -e "${CYAN}[author] Bangkiteldhian as ardx${NC}"
    echo -e "${MAGENTA}[log] $LOG_FILE${NC}"
    echo ""
}

# Show categories
show_categories() {
    echo -e "${WHITE}Available Categories:${NC}"
    
    local total_categories=${#CATEGORIES[@]}
    local half_categories=$(((total_categories + 1) / 2))

    for i in "${!CATEGORIES[@]}"; do
        local num=$((i + 1))
        local category="${CATEGORIES[$i]}"
        
        if [ $i -lt $half_categories ]; then
            printf "${GREEN}%2d${NC}) %-30s" "$num" "$category"
            
            local second_half_i=$((i + half_categories))
            if [ $second_half_i -lt $total_categories ]; then
                local second_num=$((second_half_i + 1))
                local second_category="${CATEGORIES[$second_half_i]}"
                printf "${GREEN}%2d${NC}) %-30s\n" "$second_num" "$second_category"
            else
                echo ""
            fi
        fi
    done
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Main Menu
show_main_menu() {
    echo -e "${YELLOW}           INSTALLATION OPTIONS             ${NC}"
    echo ""
    echo -e "${GREEN}1)${NC} Install ALL categories (Full Arsenal)"
    echo -e "${GREEN}2)${NC} Select specific categories"
    echo -e "${GREEN}3)${NC} Show tools statistics"
    echo -e "${GREEN}4)${NC} Verify & fix installations"
    echo -e "${GREEN}5)${NC} ${RED}UNINSTALL tools${NC} (by category/date)"
    echo -e "${GREEN}6)${NC} View installation log"
    echo -e "${GREEN}7)${NC} Generate report"
    echo -e "${GREEN}8)${NC} Search log"
    echo -e "${GREEN}9)${NC} Exit"
    echo ""
}

# ============================================================================
# INSTALLATION FUNCTIONS
# ============================================================================

# Count available tools
count_available_tools() {
    echo -e "${YELLOW}[*] Counting available tools from blackman...${NC}"
    
    if ! command -v blackman &> /dev/null; then
        echo -e "${RED}[!] blackman not found. Installing...${NC}"
        sudo pacman -S blackman --noconfirm --needed
        log_entry "INSTALL" "Installed blackman dependency"
    fi
    
    local total=$(blackman -l 2>/dev/null | grep -c .)
    echo -e "${GREEN}[+] Total available tools: ${WHITE}${total}${NC}"
    log_entry "INFO" "Total available tools: $total"
    echo ""
}

# Count installed tools
count_installed_tools() {
    echo -e "${YELLOW}[*] Counting installed BlackArch tools...${NC}"
    
    local installed=0
    for category in "${CATEGORIES[@]}"; do
        local category_pkgs_file="/tmp/baitx_cat_pkgs_$$.tmp"
        pacman -Sgq "$category" 2>/dev/null > "$category_pkgs_file"
        local cat_installed=$(comm -12 <(sort "$category_pkgs_file") <(pacman -Qq | sort) | wc -l)
        installed=$((installed + cat_installed))
        rm -f "$category_pkgs_file"
    done
    
    echo -e "${GREEN}[+] Currently installed: ${WHITE}${installed}${NC} tools"
    log_entry "INFO" "Currently installed tools: $installed"
    echo ""
}

# Install with skip error packages and logging
install_with_skip() {
    local packages_to_install=($@)
    if [ ${#packages_to_install[@]} -eq 0 ]; then
        echo -e "${YELLOW}[!] No packages to install.${NC}"
        return
    fi

    local temp_log="/tmp/baitx_install_$(date +%s).log"
    local before_file="/tmp/baitx_before_$$.txt"
    local after_file="/tmp/baitx_after_$$.txt"
    local installed_file="/tmp/baitx_installed_$$.txt"
    local error_packages=()
    local install_status=1
    
    # Record packages before installation
    pacman -Qq > "$before_file"
    
    echo -e "${BLUE}[*] Attempting installation of: ${packages_to_install[*]}${NC}"
    log_entry "INSTALL" "Starting batch install | Packages: ${#packages_to_install[@]}"
    
    sudo pacman -S "${packages_to_install[@]}" --noconfirm --needed 2>&1 | tee "$temp_log"
    install_status=${PIPESTATUS[0]}
    
    # Record packages after installation
    pacman -Qq > "$after_file"
    
    # Find newly installed packages
    comm -13 <(sort "$before_file") <(sort "$after_file") > "$installed_file"
    
    # Log each newly installed package
    if [ -s "$installed_file" ]; then
        echo -e "${GREEN}[+] Newly installed packages:${NC}"
        while IFS= read -r pkg; do
            local pkg_info=$(get_package_info "$pkg")
            local version=$(echo "$pkg_info" | cut -d'|' -f1)
            local size=$(echo "$pkg_info" | cut -d'|' -f2)
            
            record_installation "$pkg" "$CURRENT_CATEGORY" "$version" "$size"
            echo -e "${WHITE}  - $pkg${NC}"
        done < "$installed_file"
        echo ""
    fi
    
    # Detect and handle error packages
    if grep -q "error:.*signature from.*is unknown trust" "$temp_log"; then
        echo ""
        echo -e "${RED}# Signature Errors Detected${NC}"
        echo ""
        
        while IFS= read -r line; do
            pkg=$(echo "$line" | sed -E 's/^error: ([^:]+):.*/\1/' | sed 's/://')
            if [ -n "$pkg" ]; then
                error_packages+=("$pkg")
                record_failure "$pkg" "$CURRENT_CATEGORY" "signature trust error"
                echo -e "${RED}  ✗ $pkg${NC}"
            fi
        done < <(grep "^error:" "$temp_log" | grep "signature from")
        
        if [ ${#error_packages[@]} -gt 0 ]; then
            echo ""
            echo -e "${YELLOW}[*] Retrying without error packages...${NC}"
            
            local ignore_list=$(IFS=,; echo "${error_packages[*]}")
            sudo pacman -S "${packages_to_install[@]}" --ignore "$ignore_list" --noconfirm --needed
            install_status=$?
            
            if [ $install_status -eq 0 ]; then
                echo ""
                echo -e "${GREEN}# Installation completed!${NC}"
                echo -e "${YELLOW}[!] Skipped ${#error_packages[@]} problematic packages${NC}"
                log_entry "INSTALL" "Completed with ${#error_packages[@]} packages skipped due to signature errors"
            fi
        fi
    elif [ $install_status -eq 0 ]; then
        echo ""
        echo -e "${GREEN}# ✓ Installation completed successfully!${NC}"
        log_entry "INSTALL" "Batch install completed successfully"
    fi
    
    rm -f "$temp_log" "$before_file" "$after_file" "$installed_file"
}

# Verify and fix installations with logging
verify_and_fix() {
    local category="$1"
    local log_category="${2:-$category}"
    CURRENT_CATEGORY="$log_category"
    
    echo -e "${YELLOW}[*] Verifying ${category}...${NC}"
    log_entry "VERIFY" "Starting verification for: $category"
    
    local pkg_file="/tmp/baitx_pkg_${category}_$$.tmp"
    pacman -Sgq "$category" 2>/dev/null > "$pkg_file"
    
    if [ ! -s "$pkg_file" ]; then
        echo -e "${RED}[!] Cannot get package list for ${category}${NC}"
        log_entry "ERROR" "Cannot get package list for: $category"
        rm -f "$pkg_file"
        return 1
    fi
    
    local total=$(wc -l < "$pkg_file")
    local missing_file="/tmp/baitx_missing_${category}_$$.tmp"
    
    # Efficiently find missing packages
    comm -23 <(sort "$pkg_file") <(pacman -Qq | sort) > "$missing_file"
    
    local installed=$(comm -12 <(sort "$pkg_file") <(pacman -Qq | sort) | wc -l)
    local missing_count=$(grep -c . "$missing_file" 2>/dev/null)
    
    echo -e "${BLUE}  → Status: ${installed}/${total} installed${NC}"
    log_entry "VERIFY" "$category | Installed: $installed/$total | Missing: $missing_count"
    
    if [ "$missing_count" -gt 0 ]; then
        echo -e "${YELLOW}[!] Found ${missing_count} missing packages${NC}"
        echo -e "${YELLOW}[*] Installing missing packages (batch mode)...${NC}"
        
        # Read all missing packages into an array
        mapfile -t missing_packages < "$missing_file"
        
        # Log packages being installed
        log_entry "INSTALL" "Installing ${#missing_packages[@]} missing packages for $category"
        
        if sudo pacman -S "${missing_packages[@]}" --noconfirm --needed --overwrite='/usr/share/*'; then
            # Log successful installations
            for pkg in "${missing_packages[@]}"; do
                if pacman -Q "$pkg" &>/dev/null; then
                    local pkg_info=$(get_package_info "$pkg")
                    local version=$(echo "$pkg_info" | cut -d'|' -f1)
                    local size=$(echo "$pkg_info" | cut -d'|' -f2)
                    record_installation "$pkg" "$category" "$version" "$size"
                fi
            done
            
            echo ""
            echo -e "${GREEN}  Summary: ${missing_count} re-installed successfully.${NC}"
            log_entry "VERIFY" "$category | Re-installed: ${missing_count} packages"
        else
            echo ""
            echo -e "${RED}  Summary: Failed to install some of the ${missing_count} missing packages.${NC}"
            log_entry "ERROR" "$category | Failed to re-install some packages"
        fi
        
        sudo pacman -Scc --noconfirm &>/dev/null
    else
        echo -e "${GREEN}  ✓ All packages for this category are already installed!${NC}"
        log_entry "VERIFY" "$category | All packages already installed"
    fi
    
    rm -f "$pkg_file" "$missing_file"
    return 0
}

# ============================================================================
# MENU OPTION FUNCTIONS
# ============================================================================

# Option 1: Install All
install_all() {
    echo ""
    echo -e "${RED}  WARNING: FULL INSTALLATION                ${NC}"
    echo -e "${RED}  This will install ALL BlackArch tools!    ${NC}"
    echo -e "${RED}  Required: 90GB+ disk space (may vary)     ${NC}"
    echo ""
    
    count_available_tools
    
    read -p "Continue? [y/N]: " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Cancelled.${NC}"
        log_entry "USER" "Cancelled full installation"
        return
    fi
    
    log_entry "USER" "Started full installation of all categories"
    backup_system_state
    
    echo ""
    echo -e "${BLUE}[*] Starting full installation...${NC}"
    echo -e "${YELLOW}[*] This will take a while. Grab a coffee ☕${NC}"
    echo ""
    
    local total=${#CATEGORIES[@]}
    local current=0
    local total_installed=0
    local total_failed=0
    local total_skipped=0
    
    for category in "${CATEGORIES[@]}"; do
        current=$((current + 1))
        echo ""
        start_category "$category"
        
        local before_count=$(wc -l < "$INSTALLED_PKGS_FILE" 2>/dev/null)
        
        install_with_skip "$category"
        verify_and_fix "$category"
        
        local after_count=$(wc -l < "$INSTALLED_PKGS_FILE" 2>/dev/null)
        local cat_installed=$((after_count - before_count))
        
        total_installed=$((total_installed + cat_installed))
        
        end_category "$category" "unknown" "$cat_installed" "0" "0"
    done
    
    local duration=$(($(date +%s) - $(date -d "$SESSION_START_TIME" +%s 2>/dev/null || echo 0)))
    local duration_str="${duration}s"
    
    echo ""
    echo -e "${GREEN}# ✓ Full installation completed!${NC}"
    echo ""
    
    record_session_summary "$total" "$total_installed" "$total_failed" "$total_skipped" "$duration_str"
    count_installed_tools
}

# Option 2: Select Categories
select_categories() {
    echo ""
    show_categories
    
    echo -e "${GREEN}Enter category numbers (space-separated, e.g: 1 12 15):${NC}"
    read -p "> " selections
    
    if [ -z "$selections" ]; then
        echo -e "${RED}[!] No selection made${NC}"
        return
    fi
    
    local selected_cats=()
    for num in $selections; do
        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#CATEGORIES[@]} ]; then
            local idx=$((num - 1))
            selected_cats+=("${CATEGORIES[$idx]}")
        else
            echo -e "${RED}[!] Invalid number: $num${NC}"
        fi
    done
    
    if [ ${#selected_cats[@]} -eq 0 ]; then
        echo -e "${RED}[!] No valid categories selected${NC}"
        return
    fi
    
    echo ""
    echo -e "${CYAN}Selected categories:${NC}"
    for cat in "${selected_cats[@]}"; do
        echo -e "${GREEN}  ✓ $cat${NC}"
    done
    echo ""
    
    read -p "Proceed with installation? [Y/n]: " confirm
    if [[ $confirm =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}Cancelled.${NC}"
        log_entry "USER" "Cancelled category selection"
        return
    fi
    
    log_entry "USER" "Started installation for categories: ${selected_cats[*]}"
    backup_system_state
    
    echo ""
    echo -e "${BLUE}[*] Installing selected categories...${NC}"
    echo ""
    
    install_with_skip "${selected_cats[@]}"
    
    echo ""
    echo -e "${YELLOW}[*] Verifying installations...${NC}"
    for cat in "${selected_cats[@]}"; do
        verify_and_fix "$cat"
    done
    
    local duration=$(($(date +%s) - $(date -d "$SESSION_START_TIME" +%s 2>/dev/null || echo 0)))
    record_session_summary "${#selected_cats[@]}" "unknown" "0" "0" "${duration}s"
    
    echo ""
    count_installed_tools
}

# Option 3: Statistics
show_statistics() {
    echo ""
    echo -e "${WHITE}              BLACKARCH TOOLS STATISTICS${NC}"
    echo ""
    
    count_available_tools
    count_installed_tools
    
    echo -e "${YELLOW}[*] Categories breakdown:${NC}"
    echo ""
    
    local installed_pkgs_file="/tmp/baitx_installed_pkgs_$$.tmp"
    pacman -Qq > "$installed_pkgs_file"
    
    for category in "${CATEGORIES[@]}"; do
        local category_pkgs_file="/tmp/baitx_cat_pkgs_$$.tmp"
        pacman -Sgq "$category" 2>/dev/null > "$category_pkgs_file"

        local count=$(wc -l < "$category_pkgs_file")
        local installed=$(comm -12 <(sort "$category_pkgs_file") <(sort "$installed_pkgs_file") | wc -l)
        
        printf "${GREEN}%-30s${NC} : ${WHITE}%4d${NC} tools (${CYAN}%4d${NC} installed)\n" "$category" "$count" "$installed"
        rm -f "$category_pkgs_file"
    done
    
    rm -f "$installed_pkgs_file"
    
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Show logged statistics
    if [ -f "$LOG_FILE" ]; then
        local total_logged=$(wc -l < "$INSTALLED_PKGS_FILE" 2>/dev/null)
        echo -e "${YELLOW}Logged Installations:${NC} $total_logged"
    fi
}

# Option 4: Verify & Fix
verify_all() {
    echo ""
    echo -e "${YELLOW}[*] Checking all installed categories for missing packages...${NC}"
    echo ""
    
    local installed_pkgs_file="/tmp/baitx_installed_pkgs_$$.tmp"
    pacman -Qq | grep '^blackarch' > "$installed_pkgs_file"

    if [ ! -s "$installed_pkgs_file" ]; then
        echo -e "${YELLOW}[!] No BlackArch packages seem to be installed.${NC}"
        rm -f "$installed_pkgs_file"
        return
    fi

    local categories_to_check=()
    for category in "${CATEGORIES[@]}"; do
        if pacman -Sgq "$category" 2>/dev/null | grep -qf "$installed_pkgs_file"; then
             categories_to_check+=("$category")
        fi
    done
    
    if [ ${#categories_to_check[@]} -eq 0 ]; then
        echo -e "${YELLOW}[!] No BlackArch categories with installed tools found.${NC}"
        echo -e "${BLUE}[*] Use option 1 or 2 to install tools first.${NC}"
        rm -f "$installed_pkgs_file"
        return
    fi
    
    echo -e "${GREEN}[+] Found ${#categories_to_check[@]} categories to verify.${NC}"
    echo ""
    
    log_entry "VERIFY" "Starting full verification of ${#categories_to_check[@]} categories"
    
    for category in "${categories_to_check[@]}"; do
        verify_and_fix "$category"
        echo ""
    done
    
    rm -f "$installed_pkgs_file"
    echo -e "${GREEN}[+] Verification complete!${NC}"
    echo ""
    count_installed_tools
}

# Option 5: Uninstall Menu
uninstall_menu() {
    echo ""
    echo -e "${RED}              UNINSTALL OPTIONS${NC}"
    echo ""
    echo -e "${GREEN}1)${NC} Uninstall by Category"
    echo -e "${GREEN}2)${NC} Uninstall by Date Range"
    echo -e "${GREEN}3)${NC} View installed packages log"
    echo -e "${GREEN}4)${NC} Back to Main Menu"
    echo ""
    read -p "Select option [1-4]: " uninstall_choice
    
    case $uninstall_choice in
        1)
            echo ""
            show_categories
            echo -e "${GREEN}Enter category number to uninstall:${NC}"
            read -p "> " cat_num
            
            if [[ "$cat_num" =~ ^[0-9]+$ ]] && [ "$cat_num" -ge 1 ] && [ "$cat_num" -le ${#CATEGORIES[@]} ]; then
                local idx=$((cat_num - 1))
                uninstall_by_category "${CATEGORIES[$idx]}"
            else
                echo -e "${RED}[!] Invalid category number${NC}"
            fi
            ;;
        2)
            echo ""
            echo -e "${YELLOW}Enter date range (YYYY-MM-DD format):${NC}"
            read -p "Start date: " start_date
            read -p "End date: " end_date
            
            if [[ "$start_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && [[ "$end_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                uninstall_by_date "$start_date" "$end_date"
            else
                echo -e "${RED}[!] Invalid date format. Use YYYY-MM-DD${NC}"
            fi
            ;;
        3)
            echo ""
            if [ -f "$INSTALLED_PKGS_FILE" ]; then
                echo -e "${CYAN}Installed Packages Log:${NC}"
                echo ""
                cat "$INSTALLED_PKGS_FILE" | column -t -s'|'
            else
                echo -e "${YELLOW}[!] No installed packages log found${NC}"
            fi
            ;;
        4)
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid option${NC}"
            ;;
    esac
}

# Option 6: View Log
view_log_menu() {
    view_log
}

# Option 7: Generate Report
generate_report_menu() {
    generate_report
}

# Option 8: Search Log
search_log_menu() {
    echo ""
    read -p "Enter search keyword: " keyword
    if [ -n "$keyword" ]; then
        search_log "$keyword"
    fi
}

# ============================================================================
# MAIN LOOP
# ============================================================================

main() {
    # Initialize logging system
    init_logging "$@"
    
    while true; do
        show_main_menu
        read -p "Select option [1-9]: " choice
        
        case $choice in
            1)
                install_all
                ;;
            2)
                select_categories
                ;;
            3)
                show_statistics
                ;;
            4)
                verify_all
                ;;
            5)
                uninstall_menu
                ;;
            6)
                view_log_menu
                ;;
            7)
                generate_report_menu
                ;;
            8)
                search_log_menu
                ;;
            9)
                echo ""
                echo -e "${GREEN}Thanks for using baitx! Happy Hacking! 🚀${NC}"
                log_entry "SYSTEM" "User exited - Session ended"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Invalid option${NC}"
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
        clear
        show_banner
    done
}

# Run
main "$@"
