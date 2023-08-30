#!/bin/bash

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

    # Add this function to check for vulnerabilities
    check_vulnerabilities() {
        package=$1
        version=$2
        api_key="501637d2-148e-4395-9a16-45cebe9e9990"
    
        # You'll need to replace this with actual code to fetch vulnerability information.
        # You can use vulnerability databases' APIs or web scraping techniques.
        # Example: Using the NVD API (replace with actual code)
        vulnerability_info=$(curl -s "https://services.nvd.nist.gov/rest/json/cve/1.0?cpeMatchString=cpe:/a:$package:$package:$version")
    
        # Parse and check vulnerability information
        if [[ "$vulnerability_info" != "No matching records found" ]]; then
        echo -e "\n${yellow}Warning: Package '$package' version $version has known vulnerabilities:${reset}"
        echo "$vulnerability_info"
        fi
    }

    # Loop through each installed package and check for outdated versions #####################
    for package in $installed_packages; do
        installed_version=$(dpkg -l | awk "\$2==\"$package\"" | awk '{print $3}')
        latest_version=$(apt-cache policy "$package" | awk '/Candidate:/ {print $2}')

        if [[ -n "$installed_version" && -n "$latest_version" ]]; then
            if [[ "$installed_version" != "$latest_version" ]]; then
                                    echo -e "\n${red}- Package '$package' is outdated.${reset} Installed version: $installed_version, Latest version: $latest_version"

                                    # Call vulnerability check function
                                    check_vulnerabilities "$package" "$installed_version"
            fi
        else
            echo "Package '$package' not found or version information not available."
        fi

        # Increment the progress counter #####################
        ((progress++))
        echo -ne "\rProgress: [$progress/$total_packages]"
    done

    echo -e "\n$blue** Checked $progress/$total_packages packages.$reset"
    echo -e "\n$green** Checking complete! **$reset"
else
    echo -e "\n$red Skipping...$reset"
    sleep 1 
fi

    