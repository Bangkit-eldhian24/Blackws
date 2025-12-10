#!/bin/bash

# BL4RX - BlackArch Ultimate Installer
# Full-featured installer with category selection and tools verification

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# ASCII Art Banner
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
echo -e "${GREEN}[info]${NC} ${WHITE}blackarch installer tools${NC}, ${RED}execution${NC}"
echo -e "${CYAN}[author] Bangkiteldhian as ardx${NC}"
echo ""

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

# Fungsi untuk menghitung total tools tersedia
count_available_tools() {
    echo -e "${YELLOW}[*] Counting available tools from blackman...${NC}"
    
    if ! command -v blackman &> /dev/null; then
        echo -e "${RED}[!] blackman not found. Installing...${NC}"
        sudo pacman -S blackman --noconfirm --needed
    fi
    
    local total=$(blackman -l 2>/dev/null | wc -l)
    echo -e "${GREEN}[+] Total available tools: ${WHITE}${total}${NC}"
    echo ""
}

# Fungsi untuk menghitung tools terinstall
count_installed_tools() {
    echo -e "${YELLOW}[*] Counting installed BlackArch tools...${NC}"
    
    local installed=$(pacman -Qq | grep -E '^(blackarch-|.*-git$)' | wc -l)
    echo -e "${GREEN}[+] Currently installed: ${WHITE}${installed}${NC} tools"
    echo ""
}

# Fungsi untuk menampilkan kategori
show_categories() {
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}Available Categories:${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    
    local col1_end=25
    local col2_start=26
    
    for i in "${!CATEGORIES[@]}"; do
        local num=$((i + 1))
        local category="${CATEGORIES[$i]}"
        
        if [ $i -lt $col1_end ]; then
            printf "${GREEN}%2d${NC}) %-30s" "$num" "$category"
            if [ $((i + 1)) -lt ${#CATEGORIES[@]} ]; then
                local next_i=$((i + col1_end))
                if [ $next_i -lt ${#CATEGORIES[@]} ]; then
                    local next_num=$((next_i + 1))
                    local next_category="${CATEGORIES[$next_i]}"
                    printf "${GREEN}%2d${NC}) %-30s\n" "$next_num" "$next_category"
                else
                    echo ""
                fi
            else
                echo ""
            fi
        fi
    done
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Fungsi untuk install dengan skip error packages
install_with_skip() {
    local packages=$1
    local temp_log="/tmp/bl4rx_install_$(date +%s).log"
    local error_packages=()
    
    echo -e "${BLUE}[*] Attempting installation...${NC}"
    sudo pacman -S $packages --noconfirm --needed 2>&1 | tee "$temp_log"
    
    # Deteksi error packages
    if grep -q "error:.*signature from.*is unknown trust" "$temp_log"; then
        echo ""
        echo -e "${RED}# Signature Errors Detected${NC}"
        echo ""
        
        while IFS= read -r pkg; do
            if [ -n "$pkg" ]; then
                error_packages+=("$pkg")
                echo -e "${RED}  ✗ $pkg${NC}"
            fi
        done < <(grep "^error:" "$temp_log" | grep "signature from" | awk '{print $2}' | sed 's/://' | sort -u)
        
        if [ ${#error_packages[@]} -gt 0 ]; then
            echo ""
            echo -e "${YELLOW}[*] Retrying without error packages...${NC}"
            
            local ignore_list=$(IFS=,; echo "${error_packages[*]}")
            sudo pacman -S $packages --ignore "$ignore_list" --noconfirm --needed
            
            if [ $? -eq 0 ]; then
                echo ""
                echo -e "${GREEN}# Installation completed!${NC}"
                echo -e "${YELLOW}[!] Skipped ${#error_packages[@]} problematic packages${NC}"
            fi
        fi
    elif [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}# ✓ Installation completed successfully!${NC}"
    fi
    
    rm -f "$temp_log"
}

# Fungsi untuk verifikasi dan install ulang tools yang gagal
verify_and_fix() {
    local category=$1
    echo -e "${YELLOW}[*] Verifying ${category}...${NC}"
    
    # Get list of packages in category
    local pkg_list=$(pacman -Sgq "$category" 2>/dev/null)
    
    if [ -z "$pkg_list" ]; then
        echo -e "${RED}[!] Cannot get package list for ${category}${NC}"
        return 1
    fi
    
    local total=0
    local missing=()
    local installed=0
    
    while IFS= read -r pkg; do
        total=$((total + 1))
        if pacman -Qq "$pkg" &>/dev/null; then
            installed=$((installed + 1))
        else
            missing+=("$pkg")
        fi
    done <<< "$pkg_list"
    
    echo -e "${BLUE}  → Status: ${installed}/${total} installed${NC}"
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${YELLOW}[!] Found ${#missing[@]} missing packages${NC}"
        echo -e "${YELLOW}[*] Attempting to install missing packages...${NC}"
        
        local success=0
        local failed=0
        
        for pkg in "${missing[@]}"; do
            echo -e "${BLUE}  → Installing $pkg...${NC}"
            
            if sudo pacman -S "$pkg" --noconfirm --needed --overwrite='*' &>/dev/null; then
                echo -e "${GREEN}    ✓ $pkg installed${NC}"
                success=$((success + 1))
            else
                echo -e "${RED}    ✗ $pkg failed (signature/dependency issue)${NC}"
                failed=$((failed + 1))
            fi
        done
        
        echo ""
        echo -e "${GREEN}  Summary: ${success} installed, ${failed} failed${NC}"
    else
        echo -e "${GREEN}  ✓ All packages installed successfully!${NC}"
    fi
    
    return 0
}

# Main Menu
show_main_menu() {
    echo -e "${MAGENTA}╔════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║           INSTALLATION OPTIONS             ║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}1)${NC} Install ALL categories (Full Arsenal)"
    echo -e "${GREEN}2)${NC} Select specific categories"
    echo -e "${GREEN}3)${NC} Show tools statistics"
    echo -e "${GREEN}4)${NC} Verify & fix installations"
    echo -e "${GREEN}5)${NC} Exit"
    echo ""
}

# Option 1: Install All
install_all() {
    echo ""
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  WARNING: FULL INSTALLATION                ║${NC}"
    echo -e "${RED}║  This will install ALL BlackArch tools!    ║${NC}"
    echo -e "${RED}║  Required: ~60GB+ disk space               ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    echo ""
    
    count_available_tools
    
    read -p "Continue? [y/N]: " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Cancelled.${NC}"
        return
    fi
    
    echo ""
    echo -e "${BLUE}[*] Starting full installation...${NC}"
    echo -e "${YELLOW}[*] This will take a while. Grab a coffee ☕${NC}"
    echo ""
    
    # Install kategori satu per satu
    local total=${#CATEGORIES[@]}
    local current=0
    
    for category in "${CATEGORIES[@]}"; do
        current=$((current + 1))
        echo ""
        echo -e "${CYAN}[${current}/${total}] Installing ${category}...${NC}"
        install_with_skip "$category"
        
        # Verify setelah install
        verify_and_fix "$category"
    done
    
    echo ""
    echo -e "${GREEN}# ✓ Full installation completed!${NC}"
    echo ""
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
        return
    fi
    
    echo ""
    echo -e "${BLUE}[*] Installing selected categories...${NC}"
    echo ""
    
    install_with_skip "${selected_cats[*]}"
    
    # Verify each category
    echo ""
    echo -e "${YELLOW}[*] Verifying installations...${NC}"
    for cat in "${selected_cats[@]}"; do
        verify_and_fix "$cat"
    done
    
    echo ""
    count_installed_tools
}

# Option 3: Statistics
show_statistics() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}              BLACKARCH TOOLS STATISTICS${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    
    count_available_tools
    count_installed_tools
    
    echo -e "${YELLOW}[*] Categories breakdown:${NC}"
    echo ""
    
    for category in "${CATEGORIES[@]}"; do
        local count=$(pacman -Sgq "$category" 2>/dev/null | wc -l)
        local installed=$(pacman -Sgq "$category" 2>/dev/null | while read pkg; do pacman -Qq "$pkg" 2>/dev/null; done | wc -l)
        
        printf "${GREEN}%-30s${NC} : ${WHITE}%4d${NC} tools (${CYAN}%4d${NC} installed)\n" "$category" "$count" "$installed"
    done
    
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Option 4: Verify & Fix
verify_all() {
    echo ""
    echo -e "${YELLOW}[*] Checking installed categories...${NC}"
    echo ""
    
    local categories_to_check=()
    
    # Cari kategori yang sudah punya tools terinstall
    for category in "${CATEGORIES[@]}"; do
        local installed=$(pacman -Sgq "$category" 2>/dev/null | while read pkg; do pacman -Qq "$pkg" 2>/dev/null && echo 1; done | wc -l)
        
        if [ "$installed" -gt 0 ]; then
            categories_to_check+=("$category")
        fi
    done
    
    if [ ${#categories_to_check[@]} -eq 0 ]; then
        echo -e "${YELLOW}[!] No BlackArch categories installed yet${NC}"
        echo -e "${BLUE}[*] Use option 1 or 2 to install tools first${NC}"
        return
    fi
    
    echo -e "${GREEN}[+] Found ${#categories_to_check[@]} categories with installed tools${NC}"
    echo ""
    
    for category in "${categories_to_check[@]}"; do
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        verify_and_fix "$category"
        echo ""
    done
    
    echo -e "${GREEN}[+] Verification complete!${NC}"
    echo ""
    count_installed_tools
}

# Main Loop
main() {
    while true; do
        show_main_menu
        read -p "Select option [1-5]: " choice
        
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
                echo ""
                echo -e "${GREEN}Thanks for using BL4RX! Happy Hacking! 🚀${NC}"
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
        
        # Tampilkan banner lagi
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
        echo -e "${GREEN}[info]${NC} ${WHITE}blackarch installer tools${NC}, ${RED}execution${NC}"
        echo ""
    done
}

# Run
main