#!/bin/bash

###########################################################################
# enumBase - Basic Enumeration Script for Linux Systems
#
# This script is designed to assist in the enumeration of Linux systems.
# It provides a menu-based interface for selecting various sections of
# system information to gather, including network scanning, user details,
# operating system info, installed applications, cron jobs, network info,
# sensitive files, home and root directories, file system details,
# software versions, and system audits using Lynis.
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
bg_yellow='\e[43m'
reset='\e[0;0m'
bold='\e[01m'
underline='\e[04m'

# Title #####################
echo
echo -e " $green--------------------------------------------------------------------"
 echo -e "$green|                                 $yellow######      #      #####   ####### $green|"
 sleep .2 
 echo -e "$green|$blue ######  #    #  #    #  #    #  $yellow#     #    # #    #     #  #       $green|"       
 sleep .2
 echo -e "$green|$blue #       ##   #  #    #  ##  ##  $yellow#     #   #   #   #        #       $green|"       
 sleep .2
 echo -e "$green|$blue #####   # #  #  #    #  # ## #  $yellow######   #     #   #####   #####   $green|"   
 sleep .2
 echo -e "$green|$blue #       #  # #  #    #  #    #  $yellow#     #  #######        #  #       $green|"       
 sleep .2
 echo -e "$green|$blue #       #   ##  #    #  #    #  $yellow#     #  #     #  #     #  #       $green|"       
 sleep .2
 echo -e "$green|$blue ######  #    #   ####   #    #  $yellow######   #     #   #####   ####### $green|$reset"
 sleep .2
 echo -e "$green|$reset by: Mike Graham @grahmik                                           $green|"
 echo -e " --------------------------------------------------------------------$reset"
 sleep 1

# Remove the enum directory if it exists #####################
rm -r .enum 2>/dev/null

# Create the enum directory & move into it #####################
echo -e "\n$red** Creating hidden directory '.enum'. Some results will be saved there **$reset\n"
mkdir .enum && cd .enum

sleep 2

# Function to display section headers #####################
section_header() {
    echo -e "$black$bg_yellow\n"
    echo -e " ⬇️⬇️⬇️$1⬇️⬇️⬇️ "
    echo -e "$reset"
}

# Function to display titles #####################
titles() {
    echo -e "$blue\n$1$reset"
}

# Loop to keep going until user selects "Exit" #####################
while true; do

    # Display menu and capture user selections#####################
    section_header "[Menu]"

    echo -e "$blue** Select options by entering the corresponding numbers separated by spaces **\n$reset"
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
    echo " 12) Exit"

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
            12) echo -e "\n$red** Exiting **\n"; exit 0;;
            *) echo -e "\n$red** Invalid selection: $selection **$reset\n"; sleep 1;;
        esac
    done

    # Loop through selected sections #####################
    for selected_opt in "${selected_options[@]}"; do
        case $selected_opt in
            "NMAP Scan")
                ip_local=$(ip -o -f inet addr show | grep "scope global" | awk -F ' ' '{ print $4 }')
                # Nmap scan #####################
                section_header "[NMAP: Scanning $ip_local]"
                nmap -sC -sV $ip_local -oA nmap_results
                sleep 1
                ;;
            # User information #####################
            "User Information")
                user_info_output="user_info.txt"

                {
                    section_header "[User Information]"
    
                    titles "Current User: "
                    whoami
                    titles "Current User ID: "
                    id
                    titles "PATH: "
                    $PATH
                    titles "Recent Users: "
                    last
                    titles "Logged In Users: "
                    w
                    titles "Sudoers: "
                    cat /etc/sudoers
                    titles "Current User Sudo Privs: "
                    sudo -l
                } | tee "$user_info_output"
                sleep 1
                ;;
            # Operating system information ##################### 
            "Operating System Info")
                os_info_output="os_info.txt"
                {
                    section_header "[Operating System & Version Info]"

                    titles "OS: "
                    cat /etc/issue
                    titles "Version Info: "
                    cat /etc/*-release
                    titles "Kernel Info: "
                    cat /proc/version
                } | tee "$os_info_output"
                sleep 1
                ;;
            # Apps and services #####################
            "Apps & Services")
                app_serv_info="apps_and_services.txt"
                {
                    section_header "[Apps & Services]"

                    titles "Apps & Services Running As ROOT:"
                    ps aux | grep root
                    dpkg -l > installed_applications.txt
                    echo -e "\n$red** Check the hidden directory '.enum' to see a list of installed applications **$reset"
                } | tee "$app_serv_info"
                sleep 1
                ;;
            # Cron jobs #####################
            "Cron Jobs")
                section_header "[Cron Jobs]"
    
                titles "Crontab: "
                crontab -l
    
                echo -e "\n$red** Check the hidden directory '.enum' for info on daily, hourly, and monthly cron jobs **$reset"
    
                cat /etc/cron.daily/* > cron_daily.txt
                cat /etc/cron.hourly/* > cron_hourly.txt
                cat /etc/cron.monthly/* > cron_monthly.txt
                sleep 1
                ;;
            # Network information #####################
            "Network Info")
                network="network_info.txt"
                {
                    section_header "[Network]"

                    titles "Local Network: "
                    ifconfig
                    titles "IP Link: "
                    ip link
                } | tee "$network"
                sleep 1
                ;;
            # Sensitive files #####################
            "Sensitive Files")
                files="sensitive_files.txt"
                {
                    section_header "[Sensitive Files]"

                    titles "/etc/passwd:"
                    cat /etc/passwd
                    titles "/etc/group: "
                    cat /etc/group
                    titles "/etc/shadow: "
                    cat /etc/shadow

                    echo -e "\n$red** If /etc/shadow is accessible, use John The Ripper to crack password hashes **$reset"
                } | tee "$files"
                sleep 1
                ;;
            # Home and root directories #####################
            "Home & Root Directories")
                section_header "[Home & ROOT Directories]"

                titles "Home Directory: "
                ls -ahlR /home/ > home_dir.txt
                echo -e "$red** Check the hidden directory '.enum' for 'home_dir.txt' **$reset"
                titles "Root Directory: "
                ls -ahlR /root/ > root_dir.txt
                echo -e "$red** Check the hidden directory '.enum' for 'root_dir.txt' **$reset"
                sleep 1
                ;;
            # File systems #####################
            "File Systems")
                filesys="file_systems.txt"
                {
                    section_header "[File Systems]"

                    titles "File Systems Mounts: "
                    mount
                    titles "Disk Usage/Mounts: "
                    df -h
                    titles "Unmounted File Systems: "
                    cat /etc/fstab
                    titles "Writeable Folders And Files: "
                    find / -xdev -type d -perm -0002 -ls 2> /dev/null
                    find / -xdev -type f -perm -0002 -ls 2> /dev/null
                    titles "Current User Permissions:"
                    echo -e "$red** To run this enumeration, open enumBase.sh and un-comment this command. Can take a long time **$reset"
                    #find / -perm -4000 -user root -exec ls -ld {} \; 2> /dev/null
                } | tee "$filesys"
                sleep 1
                ;;
            # Software versions #####################
            "Software Versions")
                software="software_version.txt"

                {
                    section_header "[Software]"

                    titles "perl: "
                    which perl
                    titles "python: "
                    which python
                    titles "python3: "
                    which python3
                    titles "wget: "
                    which wget
                    titles "netcat: "
                    which nc
                    which netcat
                } | tee "$software"
                sleep 1
                ;;
            # Lynis #####################
            "Lynis Scan")
                # Install Lynis (if not already installed) #####################
                if ! command -v lynis &>/dev/null; then
                    echo "Installing Lynis..."
                    sudo apt-get update
                    sudo apt-get install -y lynis
                fi
                
                section_header "[Lynis System Audit]"
                lynis audit system
                sleep 1
                ;;
        esac
    done
done