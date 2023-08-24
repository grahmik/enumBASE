#!/bin/bash





# Title
 echo -e "\n\n                                \033[33m######      #      #####   #######"
 sleep .2 
 echo -e "\033[34m######  #    #  #    #  #    #  \033[33m#     #    # #    #     #  #"       
 sleep .2
 echo -e "\033[34m#       ##   #  #    #  ##  ##  \033[33m#     #   #   #   #        #"       
 sleep .2
 echo -e "\033[34m#####   # #  #  #    #  # ## #  \033[33m######   #     #   #####   #####"   
 sleep .2
 echo -e "\033[34m#       #  # #  #    #  #    #  \033[33m#     #  #######        #  #"       
 sleep .2
 echo -e "\033[34m#       #   ##  #    #  #    #  \033[33m#     #  #     #  #     #  #"       
 sleep .2
 echo -e "\033[34m######  #    #   ####   #    #  \033[33m######   #     #   #####   #######\033[0m"
 sleep .2
 echo -e "\nby: Mike Graham @grahmik"
 sleep 2 

# Remove the enum directory if it exists #####################
rm -r .enum 2>/dev/null

# Create the enum directory & move into it #####################
echo -e "\033[31m\nCreating hidden directory '.enum'. Some results will be saved there.\033[0m"
mkdir .enum && cd .enum

sleep 2

# Function to display section headers #####################
section_header() {
    echo -e "\033[43;30m\n"
    echo -e " ⬇️⬇️⬇️$1⬇️⬇️⬇️ "
    echo -e "\033[0m"
}

# Function to display titles #####################
titles() {
    echo -e "\033[34m\n$1\033[0m"
}

# Network information & NMAP #####################
ip_local=$(ip -o -f inet addr show | grep "scope global" | awk -F ' ' '{ print $4 }')

section_header "[NMAP Scanning $ip_local]"
nmap -sC -sV $ip_local -oA nmap_results

sleep 1

# User information #####################
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

# Operating system information #####################
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

# Applications and services #####################
app_serv_info="apps_and_services.txt"
{
    section_header "[Apps & Services]"

    titles "Apps & Services Running As ROOT:"
    ps aux | grep root
    dpkg -l > installed_applications.txt
    echo -e "\033[31m\nCheck the hidden directory '.enum' to see a list of installed applications.\033[0m"
} | tee "$app_serv_info"

sleep 1

# Crontab information #####################
section_header "[Cron Jobs]"
    
titles "Crontab: "
crontab -l
    
echo -e "\033[31m\nCheck the hidden directory '.enum' for info on daily, hourly, and monthly cron jobs.\033[0m"
    
cat /etc/cron.daily/* > cron_daily.txt
cat /etc/cron.hourly/* > cron_hourly.txt
cat /etc/cron.monthly/* > cron_monthly.txt 

sleep 1

# Network information #####################
network="network_info.txt"
{
    section_header "[Network]"

    titles "Local Network: "
    ifconfig
    titles "IP Link: "
    ip link
} | tee "$network"

sleep 1

# Sensitive files #####################
files="sensitive_files.txt"
{
    section_header "[Sensitive Files]"

    titles "/etc/passwd:"
    cat /etc/passwd
    titles "/etc/group: "
    cat /etc/group
    titles "/etc/shadow: "
    cat /etc/shadow

    echo -e "\033[31m\nIf /etc/shadow is accessible, use John The Ripper to crack password hashes.\033[0m"
} | tee "$files"

sleep 1

# Home & root directories #####################
section_header "[Home & ROOT Directories]"

titles "Home Directory: "
ls -ahlR /home/ > home_dir.txt
echo -e "\033[31mCheck the hidden directory '.enum' for 'home_dir.txt'.\033[0m"
titles "Root Directory: "
ls -ahlR /root/ > root_dir.txt
echo -e "\033[31mCheck the hidden directory '.enum' for 'root_dir.txt'.\033[0m"

sleep 1

# File systems #####################
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
    echo "\033[31mTo run this enumeration, open enumBase.sh and un-comment this command. Can take a long time.\033[0m"
    #find / -perm -4000 -user root -exec ls -ld {} \; 2> /dev/null
} | tee "$filesys"

sleep 1

# Software versions #####################
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
