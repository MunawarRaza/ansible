#!/bin/bash
set -e

## Enable below lines if Variables are not being taken from ansible script
# SCRIPT_DIR=$(dirname $0)
# source ${SCRIPT_DIR}/.env

## Enable below lines if Variables are being taken from ansible script
CURRENT_DATE="${1}"
ENV_NAME="${2}"
SOURCE_MACHINE="${3}"
SOURCE_BASE_PATH="${4}"
SOURCE_FOLDER="${5}"
TEMP_DESTINATION_BASE_PATH="${6}"
FINAL_DESTINATION_BASE_PATH="${7}"
DEPLOYMENTS_FOLDER="${8}"
CONFIGURATION_FOLDER="${9}"
PROFILES_PATH="${10}"


EXTRA_FILES=("jdk*" "*.jar" "*.jar.*" "*.jar_*" "*.jar-*" "*.out*" "*.properties.*" "*.properties-*" "*.properties_*" "*.yml.*" "*.yml-*" "*.yml_*" "*.tar*" )
EXTRA_DIRS=("java")  # Directories to delete


backup_folder() {
    echo "######### Folder Backup Function #########"
   # NEW_FOLDER_PATH="${NEW_FOLDER_BASE_PATH}/${FOLDER_NAME}-${CURRENT_DATE}"
    cp -r "${SOURCE_BASE_PATH}/${SOURCE_FOLDER}" "${TEMP_DESTINATION_BASE_PATH}/${SOURCE_FOLDER}-${CURRENT_DATE}"
}

delete_extra_files() {
    echo "######### Deleting Extra Files #########"

    # Remove extra files in deployments folder
    for EXTRA_FILE in "${EXTRA_FILES[@]}"; do
        find "${TEMP_DESTINATION_BASE_PATH}/${SOURCE_FOLDER}-${CURRENT_DATE}" -type f -name "${EXTRA_FILE}" -delete
    done
    # Remove extra directories
    for EXTRA_DIR in "${EXTRA_DIRS[@]}"; do
        find "${TEMP_DESTINATION_BASE_PATH}/${SOURCE_FOLDER}-${CURRENT_DATE}" -type d -name "${EXTRA_DIR}" -exec rm -rf {} +
    done
    echo "## All extra files have been deleted ##"
}

create_tar_file() {
    echo "######### Create Tar File #########"
    cd "${TEMP_DESTINATION_BASE_PATH}"
    # tar czf "${SOURCE_FOLDER}-${CURRENT_DATE}-${SOURCE_MACHINE}-${ENV_NAME}".tar.gz "${SOURCE_FOLDER}-${CURRENT_DATE}"
    tar cvf "${SOURCE_FOLDER}-${CURRENT_DATE}".tar "${SOURCE_FOLDER}-${CURRENT_DATE}"
}

# Execute all functions
backup_folder
delete_extra_files
create_tar_file
