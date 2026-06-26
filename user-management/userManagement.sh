#!/bin/bash
set -x

#source ./variables.sh
#CURRENT_DATE=$(date +%Y%m%d)
CURRENT_DATE="${1}" # taking this value from main.sh
ORIGINAL_FOLDER_PATH="/opt"
#FOLDER_NAME="oneload"
FOLDER_NAME="${2}" # taking this value from main.sh
# NEW_FOLDER_BASE_PATH="/home/munawar"
NEW_FOLDER_BASE_PATH="${3}" # taking this value from main.sh
NEW_FOLDER_PATH="${NEW_FOLDER_BASE_PATH}/${FOLDER_NAME}-${CURRENT_DATE}"
DEPLOYMENTS_FOLDER="deployments"
PROFILES_PATH="config/profiles"

# List of patterns to process
PATTERNS=("*-qa1.properties" "*-qa3.properties" "*-qa1.yml" "*-qa2.yml")
EXTRA_FILES=("*.jar.*" "*.jar_*" "*.jar-*" "*.out*" "*.properties.*" "*.properties-*" "*.properties_*" "*.yml.*" "*.yml-*" "*.yml_*" )

IP_MAPPINGS=(
        "10.130.25.12:3306=10.30.32.26:3333"
        "10.130.22.6=10.30.22.6"
        "10.130.22.16=10.30.22.16"
        "10.130.22.20=10.30.22.20"
        "10.130.22.21=10.30.22.21"
        "10.130.22.22=10.30.22.22"
        "10.130.22.23=10.30.22.23"
        "10.130.22.24=10.30.22.24"
        "10.130.22.25=10.30.22.25"
        "10.130.22.26=10.30.22.26"
        "10.130.22.27=10.30.22.27"
        # "10.130.23.28=10.30.22.28"
    )

backup_folder() {
    echo "######### Folder Backup Function #########"
    cp -r "${ORIGINAL_FOLDER_PATH}/${FOLDER_NAME}" "${NEW_FOLDER_PATH}"
}

delete_extra_files() {
    echo "######### Deleting Extra Files #########"

    # Remove extra files in deployments folder
    for EXTRA_FILE in "${EXTRA_FILES[@]}"; do
        find "${NEW_FOLDER_PATH}" -type f -name "${EXTRA_FILE}" -delete
    done
    echo "## All extra files have been deleted ##"
}

change_profile_in_start_sh() {
    echo "######### Changing Profile name in Start.sh #########"
    find "${NEW_FOLDER_PATH}/${DEPLOYMENTS_FOLDER}" -type f -name "start.sh" -exec sed -i \
        -E 's/application-(qa|uat)[0-9]?.properties/application.properties/g' \
        -E 's/application-(qa|uat)[0-9]?.yml/application.yml/g' {} +
}

change_property_file_name() {
    echo "######### Change Property File Name #########"

    find "${NEW_FOLDER_BASE_PATH}/${PROFILES_PATH}" -type f \( -name "*.properties" -o -name "*.yml" \) | while read -r file; do
        new_file=$(echo "$file" | sed -E 's/-(qa|uat)[0-9]?//g')
        if [[ "$file" != "$new_file" ]]; then
        mv "$file" "$new_file"
        echo "Renamed: $file -> $new_file"
        else
        echo "Skipped (no change): $file"
        fi
    done
    # find "${NEW_FOLDER_PATH}/${PROFILES_PATH}" -type f \( -name "*.properties" -o -name "*.yml" ) | while read -r file; do
    #     mv "$file" "${file/-qa[0-9]+/}"
    # done
    # find "${NEW_FOLDER_PATH}/${PROFILES_PATH}" -type f -name "*-qa2.properties" | while read -r file; do
    #     mv "$file" "${file/-qa2/}"
    # done

}

change_active_profile_in_properties() {
    echo "######### Change Active Profile #########"

    find "${NEW_FOLDER_PATH}/${PROFILES_PATH}" -type f \( -name "application.properties" -o -name "application.yml" \) -exec sed -i \
        -E 's/qa1/uat/g' {} +
        # find . -name "application.properties" -exec sed -i -e 's/qa1/qa2/g' {} +
}

change_ip() {
    echo "####### Changing IPs #######"

    for folder in "${NEW_FOLDER_PATH}/${PROFILES_PATH}"; do
        for mapping in "${IP_MAPPINGS[@]}"; do
            OLD_IP="${mapping%=*}"
            NEW_IP="${mapping#*=}"
            find "$folder" -type f \( -name "*.properties" -o -name "*.yml" \) -exec sed -i "s/$OLD_IP/$NEW_IP/g" {} +
        done
    done
}

create_tar_file() {
    echo "######### Create Tar File #########"
    cd "${NEW_FOLDER_BASE_PATH}"
    tar cvf "${FOLDER_NAME}-${CURRENT_DATE}".tar "${FOLDER_NAME}-${CURRENT_DATE}"   
}

# Execute all functions
backup_folder
delete_extra_files
change_profile_in_start_sh
change_property_file_name
change_active_profile_in_properties
change_ip
create_tar_file
