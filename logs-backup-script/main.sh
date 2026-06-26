#!/bin/bash
echo "####### Testing environment Variables or credentials file"
SCRIPT_DIR=$(dirname $0)
source ${SCRIPT_DIR}/.env
# echo $NAME
# echo ${ANSIBLE_SSH_PASS}
# for ENV in "${DEV_IPS[@]}"; do
#     echo $ENV
# done;


#!/bin/bash
#set -x

echo "####### Job Started at $(date +%Y%m%d-%H%M%S) #######"


ansible_function() {
    ansible-playbook "${ANSIBLE_BACKUP_SOURCE_PLAYBOOK}" \
    -i "${SOURCE_MACHINE}," \
    -u "${ANSIBLE_REMOTE_USER}" \
    -e SOURCE_MACHINE="${SOURCE_MACHINE}" \
    -e TARGET_MACHINE="${TARGET_MACHINE}" \
    -e ansible_ssh_pass="${ANSIBLE_SSH_PASS}" \
    -e ansible_become_pass="${ANSIBLE_BECOME_PASS}" \
    -e ANSIBLE_REMOTE_USER="${ANSIBLE_REMOTE_USER}" \
    -e ANSIBLE_USER="${ANSIBLE_USER}" \
    -e CURRENT_DATE="${CURRENT_DATE}" \
    -e SOURCE_BASE_PATH="${SOURCE_BASE_PATH}" \
    -e SOURCE_FOLDER="${SOURCE_FOLDER}" \
    -e ENV_NAME="${ENV}" \
    -e FINAL_DESTINATION_BASE_PATH="${FINAL_DESTINATION_BASE_PATH}" \
    -e SERVICE_NAME="${SERVICE_NAME}"

    if [ $? -ne 0 ]; then
        echo "❌ ERROR: ${ENV} -> ${SOURCE_MACHINE} failed"
        FAILED_HOSTS+=("${ENV}:${SOURCE_MACHINE}")
    fi
}

sync_environment() {
    for SOURCE_MACHINE in "${DEV_IPS[@]}"; do
        ansible_function
        # for SERVICE_NAME in "${SERVICE_NAME[@]}"; do
            
        # done

        # if [ ${ENV} == 'dev' ]; then
        # elif [ ${ENV} == 'qa1' ]; then
        #     for SOURCE_MACHINE in "${QA1_IPS[@]}"; do
        #         ansible_function
        #     done
        # elif [ ${ENV} == 'qa2' ]; then
        #     for SOURCE_MACHINE in "${QA2_IPS[@]}"; do
        #         ansible_function
        #     done
        # elif [ ${ENV} == 'uat' ]; then
        #     for SOURCE_MACHINE in "${UAT_IPS[@]}"; do
        #         ansible_function
        #     done
        # else
        #     echo "⚠️ Invalid environment: ${ENV}"
        # fi
    done
}


ansible_archive_local_function() {
    ansible-playbook "${ANSIBLE_ARCHIVE_LOCAL_PLAYBOOK}" \
    -e ansible_ssh_pass="${ANSIBLE_SSH_PASS}" \
    -e ansible_become_pass="${ANSIBLE_BECOME_PASS}" \
    -e ANSIBLE_REMOTE_USER="${ANSIBLE_REMOTE_USER}" \
    -e ANSIBLE_USER="${ANSIBLE_USER}" \
    -e CURRENT_DATE="${CURRENT_DATE}" \
    -e LOCAL_DESTINATION_BASE_PATH="${LOCAL_DESTINATION_BASE_PATH}" \
    -e FINAL_DESTINATION_BASE_PATH="${FINAL_DESTINATION_BASE_PATH}"
}


ansible_push_to_remote_function() {
    ansible-playbook "${ANSIBLE_PUSH_BACKUP_PLAYBOOK}" \
    -i "${BACKUP_MACHINE}," \
    -e ansible_ssh_pass="${ANSIBLE_SSH_PASS}" \
    -e ansible_become_pass="${ANSIBLE_BECOME_PASS}" \
    -e ANSIBLE_REMOTE_USER="${ANSIBLE_REMOTE_USER}" \
    -e ANSIBLE_USER="${ANSIBLE_USER}" \
    -e CURRENT_DATE="${CURRENT_DATE}" \
    -e LOCAL_DESTINATION_BASE_PATH="${LOCAL_DESTINATION_BASE_PATH}" \
    -e CURRENT_DATE="${CURRENT_DATE}" \
    -e BACKUP_MACHINE="${BACKUP_MACHINE}" \
    -e FINAL_DESTINATION_BASE_PATH="${FINAL_DESTINATION_BASE_PATH}" 

    # if [ $? -ne 0 ]; then
    #     echo "❌ ERROR: ${ENV} -> ${SOURCE_MACHINE} failed"
    #     FAILED_HOSTS+=("${ENV}:${SOURCE_MACHINE}")
    # fi
}


ansible_clean_local_disk() {
    ansible-playbook "${ANSIBLE_CLEAN_LOCAL_DISK_PLAYBOOK}" \
    -e ansible_ssh_pass="${ANSIBLE_SSH_PASS}" \
    -e ansible_become_pass="${ANSIBLE_BECOME_PASS}" \
    -e ANSIBLE_REMOTE_USER="${ANSIBLE_REMOTE_USER}" \
    -e ANSIBLE_USER="${ANSIBLE_USER}" \
    -e CURRENT_DATE="${CURRENT_DATE}" \
    -e LOCAL_DESTINATION_BASE_PATH="${LOCAL_DESTINATION_BASE_PATH}" \
    -e FINAL_DESTINATION_BASE_PATH="${FINAL_DESTINATION_BASE_PATH}"
}


sync_environment
# if [ $? -eq 0 ]; then
#     echo "✅ sync_environment completed successfully. Starting archive creation..."
#     ansible_archive_local_function
# else
#     echo "❌ sync_environment failed. Skipping archive creation."
#     exit 1
# fi
# #ansible_archive_local_function
# if [ $? -eq 0 ]; then
#     echo "✅ sync_environment completed successfully. Starting archive creation..."
#     ansible_push_to_remote_function
# else
#     echo "❌ sync_environment failed. Skipping archive creation."
#     exit 1
# fi
#ansible_push_to_remote_function
#${SCRIPT_DIR}/notification.sh "${CURRENT_DATE}" "${ENV_NAME[@]}"
# ${SCRIPT_DIR}/notification.sh "${WEBHOOK_URL}" "${THEME_COLOR}" "${LOCAL_DESTINATION_BASE_PATH}" "${CURRENT_DATE}" "${ENV_NAME[@]}"
#${SCRIPT_DIR}/notification.sh "${WEBHOOK_URL}" "${THEME_COLOR}" "${LOCAL_DESTINATION_BASE_PATH}" "${CURRENT_DATE}" "${ENV_NAME[@]}"
# ansible_clean_local_disk

echo "####### Job Completed at $(date +%Y%m%d-%H%M%S) #######"
