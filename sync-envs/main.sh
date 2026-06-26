#!/bin/bash
set -e

echo "#### Welcome to User Management with Ansible ####"

## Variables
ANSIBLE_PLAYBOOK="main.yml"
REMOTE_USER="munawar"

source ./common_variables.sh

#CURRENT_DATE=$(date +%Y%m%d)
#FOLDER_NAME="oneload"
#NEW_FOLDER_BASE_PATH="/home/munawar"

# user_input(){
#     local PROMPT="${1}"
#     local -n INPUT_REF="${2}"
#     INPUT_REF=""
#     local CHAR

#     # echo -n "$PROMPT"

#     while true; do
#         read -p "${PROMPT}" CHAR
#         read -p "You have Entered '${CHAR}'. Is this correct? (y/n): " confirmation
#             if [[ "$confirmation" =~ ^[Yy]$ ]]; then
#                # echo "Confirmed input: $USER_NAME"
#                 #INPUT_REF="$CHAR"
#                 echo $CHAR
#                 break
#             else
#                 # echo "Let's try again."
#                 CHAR=""
#             fi
#     done
# }
# # user_input(){
# #     local PROMPT="${1}"
# #     local -n INPUT_REF="${2}"
# #     INPUT_REF=""
# #     local CHAR

# #     # echo -n "$PROMPT"

# #     while true; do
# #         read -p "${PROMPT}" CHAR
# #         read -p "You have Entered '${CHAR}'. Is this correct? (y/n): " confirmation
# #             if [[ "$confirmation" =~ ^[Yy]$ ]]; then
# #                 # echo "Confirmed input: $USER_NAME"
# #                 echo "$CHAR"
# #                 break
# #             else
# #                     echo "Let's try again."
# #             fi
# #     done
# # }



# #source_machine() {
#     #user_input "Enter the source machine: " SOURCE_MACHINE
#     SOURCE_MACHINE=$(user_input "Enter the source machine: " SOURCE_MACHINE)
# }
# source_machine

# target_machine() {
#     #user_input "Enter the target machine: " TARGET_MACHINE
#     TARGET_MACHINE=$(user_input "Enter the target machine: " TARGET_MACHINE) 
# }
# target_machine

# # source_machine() {
# #     SOURCE_MACHINE=$(user_input "Enter the source machine IP: ")
# # }

# # target_machine() {
# #     TARGET_MACHINE=$(user_input "Enter the target machine IP: ")
# # }

# read_password() {
#     local PROMPT="$1"
#     local -n PASSWORD_REF="$2"
#     PASSWORD_REF=""
#     local CHAR

#     # Display the PROMPT message
#     echo -n "$PROMPT"

#     while IFS= read -r -s -n1 CHAR; do
#         # Break on Enter key (ASCII 13 or 10 depending on OS)
#         if [[ $CHAR == $'\0' || $CHAR == $'\n' ]]; then
#             break
#         fi

#         # Handle Backspace
#         if [[ $CHAR == $'\177' ]]; then
#             if [[ -n $PASSWORD_REF ]]; then
#                 PASSWORD_REF=${PASSWORD_REF%?}
#                 echo -ne "\b \b"
#             fi
#         else
#             PASSWORD_REF+="$CHAR"
#             echo -n "*"
#         fi
#     done
#     echo
# }




# read_ansible_ssh_pass() {
#     read_password "Enter SSH Password for ${REMOTE_USER} (ansible_ssh_pass): " ANSIBLE_SSH_PASS
# }

# read_ansible_become_pass() {
#     read_password "Enter sudo password for ${REMOTE_USER} (ansible_become_pass): " ANSIBLE_BECOME_PASS
# }

SOURCE_MACHINE="10.130.22.26"
TARGET_MACHINE="10.30.22.26"
ANSIBLE_SSH_PASS="Oneload!.068"
ANSIBLE_BECOME_PASS="Oneload!.068"

sync_environment() {
    #read_ansible_ssh_pass
    #read_ansible_become_pass
    echo "Source hosts is ${SOURCE_MACHINE}"
    echo "target hosts is ${TARGET_MACHINE}"

     ansible-playbook "${ANSIBLE_PLAYBOOK}" \
    -e SOURCE_MACHINE="${SOURCE_MACHINE}" \
    -e TARGET_MACHINE="${TARGET_MACHINE}" \
    -e ansible_ssh_pass="${ANSIBLE_SSH_PASS}" \
    -e ansible_become_pass="${ANSIBLE_BECOME_PASS}" \
    -e REMOTE_USER="${REMOTE_USER}" \
    -e CURRENT_DATE="${CURRENT_DATE}" \
    -e FOLDER_NAME="${FOLDER_NAME}" \
    -e NEW_FOLDER_BASE_PATH="${NEW_FOLDER_BASE_PATH}" 

}

sync_environment
