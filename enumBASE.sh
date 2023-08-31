#!/bin/bash

###########################################################################
# enumBASE - Basic Enumeration Script for Linux Systems - Get On Base
#
# This script is designed to assist in the enumeration of Linux systems.
# It provides a menu-based interface for selecting various sections of
# system information to gather, including network scanning, user details,
# operating system info, installed applications, cron jobs, network info,
# sensitive files, home and root directories, file system details,
# software versions, and system audits using Lynis (if possible).
#
# Author: Mike Graham (@grahmik)
# GitHub Repository: https://github.com/grahmik/enumBase
#
# Usage: Run the script and select desired sections to perform enumeration.
#        Results will be saved in the '.enum' directory within the script's
#        directory.
###########################################################################

# Colors and text effects #####################
red='\e[31m'
green='\e[32m'
blue='\e[34m'
yellow='\e[33m'
black='\e[30m'
gray='\e[30;1m'
bg_yellow='\e[43m'
bg_blue='\e[44m'
bg_black='\e[97m\e[40m'
reset='\e[0;0m'
bold='\e[01m'
underline='\e[04m'
italic='\033[3m'

# Title #####################
echo
echo -e "$yellow                                         _______   ______   ______  ________"
sleep .04
echo -e "                                        |       \\ /      \\ /      \\|        \\"
sleep .04
echo -e "  ______  _______  __    __ ______ ____ | ███████\\  ██████\\  ██████\\ ████████"
sleep .04
echo -e " /      \\|       \\|  \\  |  \\      \\    \\| ██__/ ██ ██__| ██ ██___\\██ ██__"
sleep .04
echo -e "|  ██████\\ ███████\\ ██  | ██ ██████\\████\\ ██    ██ ██    ██\\██    \\| ██  \\"
sleep .04
echo -e "| ██    ██ ██  | ██ ██  | ██ ██ | ██ | ██ ███████\\ ████████_\\██████\\ █████"
sleep .04
echo -e "| ████████ ██  | ██ ██__/ ██ ██ | ██ | ██ ██__/ ██ ██  | ██  \\__| ██ ██_____"
sleep .04
echo -e " \\██     \\ ██  | ██\\██    ██ ██ | ██ | ██ ██    ██ ██  | ██\\██    ██ ██     \\"
sleep .04
echo -e "  \\███████\\██   \\██ \\██████ \\██  \\██  \\██\\███████ \\██   \\██ \\██████ \\████████"
sleep .04
echo
sleep .04
echo -e "   $bg_blue$black              Get On BASE             $reset\n"
sleep .04
echo -e "   $bg_yellow                                      $reset"
sleep .04
echo -e "   $bg_yellow  $reset                                  $bg_yellow  $reset"
sleep .04
echo -e "   $bg_yellow  $reset $blue enumBASE$reset$gray ..............$reset v0.0.1  $bg_yellow  $reset"
sleep .04
echo -e "   $bg_yellow  $reset $blue Author$reset$gray ...........$reset Mike Graham  $bg_yellow  $reset"
sleep .04
echo -e "   $bg_yellow  $reset $blue htb Respect$reset$gray .........$reset @grahmik  $bg_yellow  $reset"
sleep .04
echo -e "   $bg_yellow  $reset $blue Github$reset$gray .....$reset /grahmik/enumBASE  $bg_yellow  $reset"
sleep .04
echo -e "   $bg_yellow  $reset $blue Inspiration$reset$gray ....$reset LinPEAS & lse  $bg_yellow  $reset"
sleep .04
echo -e "   $bg_yellow  $reset                                  $bg_yellow  $reset"
sleep .04
echo -e "   $bg_yellow                                      $reset"
sleep .04

# Create the enum directory & move into it #####################
mkdir .enum 2>/dev/null
cd .enum

# Advisories
echo -e "\n**$italic This script is intended for ethical hacking use only **"
sleep .04
echo -e "** Restrict use to personal computers or with explicit permission from the owner$reset **"
sleep .04
echo -e "\n$red$italic** Created hidden directory '.enum/' | Some results will be saved there **$reset"
sleep .04

# Function to display section headers #####################
section_header() {
    echo -e "\n$bg_yellow$black                            ⬇⬇⬇ $1 ⬇⬇⬇                               $reset"
    }

# Function to display titles #####################
titles() {
    echo -e "\n$blue$underline$1$reset$blue:$reset"
}

# Function to generate a timestamp in the format: YYYY-MM-DD_HH-MM-SS
timestamp() {
  date +"%Y-%m-%d_%H-%M-%S"
}

# Loop to keep going until user selects "Exit" #####################
while true; do

    # Display menu and capture user selections #####################
    section_header "[Menu]"

    echo -e "\n$blue** Select options by entering the corresponding numbers separated by spaces **\n$reset"
    echo "  1) NMAP Scan"
    echo "  2) User Information"
    echo "  3) Operating System Info"
    echo "  4) Apps & Services"
    echo "  5) Cron Jobs"
    echo "  6) Network Info"
    echo "  7) Sensitive Files"
    echo "  8) Home & Root Directories"
    echo "  9) File Systems"
    echo " 10) Software Versions"
    echo " 11) Lynis Scan"
    echo " 12) Run 2-10"
    echo " 13) Run All"
    echo "  D) Delete Logs"
    echo "  R) Remove .enum/"
    echo "  E) Exit"

    echo
    read -p "Enter your selection(s): " selection_input
    echo

    selected_options=()
    for selection in $selection_input; do
        case $selection in
            1) selected_options+=("NMAP Scan");;
            2) selected_options+=("User Information");;
            3) selected_options+=("Operating System Info");;
            4) selected_options+=("Apps & Services");;
            5) selected_options+=("Cron Jobs");;
            6) selected_options+=("Network Info");;
            7) selected_options+=("Sensitive Files");;
            8) selected_options+=("Home & Root Directories");;
            9) selected_options+=("File Systems");;
            10) selected_options+=("Software Versions");;
            11) selected_options+=("Lynis Scan");;
            12) selected_options=("User Information" "Operating System Info" "Apps & Services" "Cron Jobs" "Network Info" "Sensitive Files" "Home & Root Directories" "File Systems" "Software Versions");;
            13) selected_options=("NMAP Scan" "User Information" "Operating System Info" "Apps & Services" "Cron Jobs" "Network Info" "Sensitive Files" "Home & Root Directories" "File Systems" "Software Versions" "Lynis Scan");;
             D) selected_options+=("Delete Logs");;
             R) selected_options+=("Remove .enum/");;
             E) echo -e "\n$red$italic** Exiting **$reset\n"; sleep .04; exit 0;;
            *) echo -e "\n$red$italic** Invalid selection: $selection **$reset\n"; sleep 1;;
        esac
    done

    # Loop through selected sections #####################
    for selected_opt in "${selected_options[@]}"; do
        case $selected_opt in
            "NMAP Scan")
                ip_local=$(ip -o -f inet addr show | grep "scope global" | awk -F ' ' '{ print $4 }')
                # Nmap scan #####################
                section_header "[Nmap: $ip_local]"
                echo -e "\n$blue** Target Local Network: $yellow$ip_local$blue **$reset\n"
                nmap -sC -sV $ip_local -v -oA nmap_results
                echo
                sleep .04
                ;;
            # User information #####################
            "User Information")
                user_info_output="user_info_$(timestamp).txt"

                {
                    section_header "[User Information]"
    
                    titles "Current User"
                    whoami
                    titles "Current User ID"
                    id
                    titles "PATH"
                    echo $PATH
                    titles "Recent Users"
                    last
                    titles "Logged In Users"
                    w
                    titles "Sudoers"
                    cat /etc/sudoers
                    titles "Current User Sudo Privs"
                    sudo -l
                } | tee "$user_info_output"
                sleep .04
                ;;
            # Operating system information ##################### 
            "Operating System Info")
                os_info_output="os_info_$(timestamp).txt"
                {
                    section_header "[OS & Version Info]"

                    titles "OS"
                    cat /etc/issue
                    titles "Version Info"
                    cat /etc/*-release
                    titles "Kernel Info"
                    cat /proc/version
                } | tee "$os_info_output"
                sleep .04
                ;;
            # Apps and services #####################
            "Apps & Services")
                app_serv_info="apps_and_services_$(timestamp).txt"
                {
                    section_header "[Apps & Services]"

                    titles "Apps & Services Running As ROOT"
                    ps aux | grep root
                    titles "Apps & Services"
                    ps aux
                    dpkg -l > installed_applications.txt
                    echo -e "\n$red$italic** Check the hidden directory '.enum/' to see a list of installed applications **$reset"
                } | tee "$app_serv_info"
                sleep .04
                ;;
            # Cron jobs #####################
            "Cron Jobs")
                section_header "[Cron Jobs]"
    
                titles "Crontab"
                crontab -l
    
                echo -e "\n$red$italic** Check the hidden directory '.enum/' for info on daily, hourly, and monthly cron jobs **$reset"
    
                cat /etc/cron.daily/* > cron_daily.txt
                cat /etc/cron.hourly/* > cron_hourly.txt
                cat /etc/cron.monthly/* > cron_monthly.txt
                sleep .04
                ;;
            # Network information #####################
            "Network Info")
                network="network_info_$(timestamp).txt"
                {
                    section_header "[Network]"

                    titles "Local Network"
                    ifconfig
                    titles "IP Link"
                    ip link
                } | tee "$network"
                sleep .04
                ;;
            # Sensitive files #####################
            "Sensitive Files")
                files="sensitive_files_$(timestamp).txt"
                {
                    section_header "[Sensitive Files]"

                    titles "/etc/passwd"
                    cat /etc/passwd
                    titles "/etc/group"
                    cat /etc/group
                    titles "/etc/shadow"
                    cat /etc/shadow

                } | tee "$files"
                sleep .04
                ;;
            # Home and root directories #####################
            "Home & Root Directories")
                section_header "[Home & ROOT Dir]"

                titles "Home Directory"
                ls -ahlR /home/ > home_dir_$(timestamp).txt
                echo -e "$red$italic** Check the hidden directory '.enum/' for 'home_dir.txt' **$reset"
                titles "Root Directory"
                ls -ahlR /root/ > root_dir_$(timestamp).txt
                echo -e "$red$italic** Check the hidden directory '.enum/' for 'root_dir.txt' **$reset"
                sleep .04
                ;;
            # File systems #####################
            "File Systems")
                filesys="file_systems_$(timestamp).txt"
                {
                    section_header "[File Systems]"

                    titles "File Systems Mounts"
                    mount
                    titles "Disk Usage/Mounts"
                    df -h
                    titles "Unmounted File Systems"
                    cat /etc/fstab
                    titles "Writeable Folders And Files"
                    find / -xdev -type d -perm -0002 -ls 2> /dev/null
                    find / -xdev -type f -perm -0002 -ls 2> /dev/null
                    titles "Current User File Permissions"
                    echo -e "$red$italic** To run this enumeration, open enumBase.sh and un-comment this command. Can take a long time **$reset"
                    #find / -perm -4000 -user root -exec ls -ld {} \; 2> /dev/null
                } | tee "$filesys"
                sleep .04
                ;;
            # Software versions #####################
            "Software Versions")
                software="software_version_$(timestamp).txt"
                {
                    section_header "[Software]"

                    titles "Perl"
                    which perl
                    titles "Python"
                    which python
                    titles "Python3"
                    which python3
                    titles "Wget"
                    which wget
                    titles "Netcat"
                    which nc
                    which netcat
                    sleep .04

                    # Check for outdated software #####################
                    echo
                    read -p "Do you want to check for outdated software? Can take awhile (y/n): " check_software
                    if [[ $check_software == "y" ]]; then

                        echo -e "\n${green}** Checking for outdated software versions... **${reset}\n"

                        # Get a list of all installed packages and versions #####################
                        installed_packages=$(dpkg -l | awk '/^ii/ {print $2}')

                        # Calculate the total number of installed packages #####################
                        total_packages=$(echo "$installed_packages" | wc -l)

                        # Initialize the progress counter #####################
                        progress=0

                        # Loop through each installed package and check for outdated versions #####################
                        for package in $installed_packages; do
                            installed_version=$(dpkg -l | awk "\$2==\"$package\"" | awk '{print $3}')
                            latest_version=$(apt-cache policy "$package" | awk '/Candidate:/ {print $2}')

                            if [[ -n "$installed_version" && -n "$latest_version" ]]; then
                                if [[ "$installed_version" != "$latest_version" ]]; then
                                    echo -e "\n${red}- Package '$package' is outdated.${reset} Installed version: $installed_version, Latest version: $latest_version"
        
                                fi
                            else
                                echo "Package '$package' not found or version information not available."
                            fi

                            # Increment the progress counter #####################
                            ((progress++))
                            echo -ne "\rProgress: [$progress/$total_packages]"
                        done

                        echo -e "\n$blue** Checked $progress/$total_packages packages **$reset"
                        echo -e "\n$green** Checking complete! **$reset"
                    else
                        echo -e "\n$red Skipping...$reset"
                        sleep 1 
                    fi
                } | tee "$software"
                sleep .04
                ;;
            # Lynis #####################
            "Lynis Scan")
                section_header "[Lynis System Audit]"

                if ! command -v lynis &>/dev/null; then
                    echo
                    read -p "Lynis is not installed. Do you want to install it? (y/n): " install_lynis
                    if [[ $install_lynis == "y" ]]; then
                        echo "Installing Lynis..."
                        sleep .04
                        sudo apt-get update
                        sudo apt-get install -y lynis
                    else
                        echo -e "\n$red Skipping...$reset"
                        sleep 1
                        continue
                    fi
                fi

                lynis audit system
                sleep .04
                ;;
            # Delete logs from .enum directory #####################
            "Delete Logs")
                cd ..
                rm -r .enum/
                mkdir .enum/
                cd .enum/
                echo -e "\n$red$italic** Removed logs from '.enum/' directory **$reset"
                sleep .04
                ;;
            # Remove .enum/ directory
            "Remove .enum/")
                echo -e "\n$red$italic** Removing '.enum/' **$reset"
                cd ..
                rm -r .enum/
                sleep 1
                echo -e "\n$red$italic** Exiting **$reset\n"
                sleep .04
                exit 0
                ;;
        esac
    done
done
