#!/bin/bash

echo "#### Welcome to User Management with Ansible ####"

## Variables
DEFAULT_LOGIN_PASSWORD="Abcd@1234"
#DEFAULT_PASSWORD='$6$MR2rGrd4wqRV2lKh$z.t0f9cimCMy11RurS9vddeSRN0SLpfovsSEMd2d9nAPDSZCB1I4bXKtK46sneyKlGM2mKeqVoZfjTBSE3e5H0'
DEFAULT_PASSWORD="Abcd@1234"
ANSIBLE_PLAYBOOK="userManagement.yml"

prompt_confirmation() {
    local input
    local confirmation
    while true; do
        read -e -p  "$1: " input
        read -e -p "You entered '$input'. Is this correct? (y/n): " confirmation
        if [[ "$confirmation" =~ ^[Yy]$ ]]; then
            echo "$input"
            break
        else
            echo "Let's try again." >&2
        fi
    done
}

mask_input() {
    local var_name=$1
    local prompt_message=$2
    local input=""
    local char

    echo -n "$prompt_message: "
    while IFS= read -r -s -n1 char; do
        if [[ $char == $'\0' || $char == $'\n' ]]; then
            break
        fi
        if [[ $char == $'\177' ]]; then
            if [[ -n $input ]]; then
                input=${input%?}
                echo -ne "\b \b"
            fi
        else
            input+="$char"
            echo -n "*"
        fi
    done
    echo
    eval "$var_name='$input'"
}

ask_password_expiry() {
    local input
    while true; do
        read -p "Expire Password? (yes/no): " input
        if [[ "$input" =~ ^[Yy]es$ ]]; then
            echo "true"
            break
        elif [[ "$input" =~ ^[Nn]o$ ]]; then
            echo "false"
            break
        else
            echo "Invalid input. Please enter 'yes' or 'no'."
        fi
    done
}

execute_ansible() {
    local extra_vars="$1"
    ansible-playbook "${ANSIBLE_PLAYBOOK}" ${extra_vars}
}

success_message() {
    local IFS=','
    echo
    echo "####### Task Completed Successfully #######"
    echo "####### UserName: $*"
    echo "####### Password: ${DEFAULT_LOGIN_PASSWORD} "
    echo "###########################################"
    echo
}

## Main Logic
#TARGET_GROUP=$(prompt_confirmation "Enter Target Machines (comma-separated for multiple)")
#OPTION_NUMBER=$(prompt_confirmation "Select an Option (1- Create Simple User, 2- Create Privileged User, 3- Reset User Password, 4- Delete User, 5- Disable User, 6- Enable User)")
OPTION_NUMBER=$(prompt_confirmation "Select an Option:
1 - Create Simple User
2 - Create Privileged User
3 - Reset User Password
4 - Delete User
5 - Disable User
6 - Enable User
")

#mask_input ANSIBLE_SSH_PASS "Enter SSH Password (ansible_ssh_pass)"
#mask_input ANSIBLE_BECOME_PASS "Enter Sudo Password (ansible_become_pass)"


### Direct Input
# Dev
#TARGET_GROUP=("10.130.21.5","10.130.21.6","10.130.21.10","10.130.21.11","10.130.21.20","10.130.21.21","10.130.21.22","10.130.21.23","10.130.21.24","10.130.21.25","10.130.21.26","10.130.21.27")
# QA-1
#TARGET_GROUP=("10.130.22.5","10.130.22.6","10.130.22.10","10.130.22.11","10.130.22.20","10.130.22.21","10.130.22.22","10.130.22.23","10.130.22.24","10.130.22.25","10.130.22.26")
# QA-2
#TARGET_GROUP=("10.130.23.5","10.130.23.6","10.130.23.10","10.130.23.11","10.130.23.20","10.130.23.21","10.130.23.22","10.130.23.23","10.130.23.24","10.130.23.25","10.130.23.26")
# UAT
#TARGET_GROUP=("10.30.22.5","10.30.22.10","10.30.22.20","10.30.22.21","10.30.22.22","10.30.22.23","10.30.22.24","10.30.22.25","10.30.22.26")

# Demo
TARGET_GROUP=("10.130.22.21","10.130.22.22")

#USER_NAME=("waqas")
#EXPIRES_PASSWORD="true"
ANSIBLE_SSH_PASS="Oneload!.068"
ANSIBLE_BECOME_PASS="Oneload!.068"
ANSIBLE_REMOTE_USER="munawar" # ssh the remote server with this user
ANSIBLE_BECOME_USER="munawar" # execute commands on remote machine with this user. In this not being used for now

case $OPTION_NUMBER in
    1|2|3|4)
       USER_NAME=$(prompt_confirmation "Enter User Name (comma-separated for multiple)")
       EXPIRES_PASSWORD=$(ask_password_expiry)

        PRIVILEGED="false"
        UPDATE_PASSWORD="false"
        DELETE_USER="false"
        ENABLE_USER="false"
        DISABLE_USER="false"

        case $OPTION_NUMBER in
            1) echo "Creating Simple User"; NON_PRIVILEGED="true";;
            2) echo "Creating Privileged User"; PRIVILEGED="true";;
            3) echo "Resetting Password"; UPDATE_PASSWORD="true";;
            4) echo "Deleting User"; DELETE_USER="true";;
        esac

        IFS=',' read -r -a USER_ARRAY <<< "$USER_NAME"
        IFS=',' read -r -a TARGET_MACHINES <<< "$TARGET_GROUP"

        for TARGET_MACHINES in "${TARGET_MACHINES[@]}"; do
            TARGET_MACHINES=$(echo "$TARGET_MACHINES" | xargs) # Trim whitespace
           # echo "${TARGET_MACHINES}"
            for USER_NAME in "${USER_ARRAY[@]}"; do
                USER_NAME=$(echo "$USER_NAME" | xargs) # Trim whitespace
                # echo "${USER_NAME}"
            execute_ansible "-e ansible_ssh_pass='${ANSIBLE_SSH_PASS}' \
                            -e ansible_become_pass='${ANSIBLE_BECOME_PASS}' \
                            -e ANSIBLE_REMOTE_USER='${ANSIBLE_REMOTE_USER}' \
                            -e TARGET_MACHINES='${TARGET_MACHINES}' \
                            -e USER_NAME='${USER_NAME}' \
                            -e DEFAULT_PASSWORD='${DEFAULT_PASSWORD}' \
                            -e NON_PRIVILEGED='${NON_PRIVILEGED}' \
                            -e PRIVILEGED='${PRIVILEGED}' \
                            -e UPDATE_PASSWORD='${UPDATE_PASSWORD}' \
                            -e DELETE_USER='${DELETE_USER}' \
                            -e EXPIRES_PASSWORD='${EXPIRES_PASSWORD}'"
            done
            
        done
        success_message "${USER_ARRAY[@]}"
        # IFS=',' read -r -a USER_ARRAY <<< "$USER_NAME"
        # for USER in "${USER_ARRAY[@]}"; do
        #     USER=$(echo "$USER" | xargs) # Trim whitespace
            
        #     for USER_NAME in "${USER[@]}"; do
        #         #echo "${USER}"
        #         echo "${TARGET_GROUP}"
            # execute_ansible "-e ansible_ssh_pass='${ANSIBLE_SSH_PASS}' \
            #                 -e ansible_become_pass='${ANSIBLE_BECOME_PASS}' \
            #                 -e TARGET_MACHINE='${TARGET_GROUP}' \
            #                 -e USER_NAME='${USER_NAME}' \
            #                 -e DEFAULT_PASSWORD='${DEFAULT_PASSWORD}' \
            #                 -e PRIVILEGED='${PRIVILEGED}' \
            #                 -e UPDATE_PASSWORD='${UPDATE_PASSWORD}' \
            #                 -e DELETE_USER='${DELETE_USER}' \
            #                 -e EXPIRES_PASSWORD='${EXPIRES_PASSWORD}'"
        #     done
        # done
        # for USER_NAME in "${USER_NAME[@]}";do
        #     success_message "${USER_NAME}"
        # done
        ;;
    5|6)
       # USER_NAME=$(prompt_confirmation "Enter User Name (comma-separated for multiple)")

        IFS=',' read -r -a USER_ARRAY <<< "$USER_NAME"
        IFS=',' read -r -a TARGET_MACHINES <<< "$TARGET_GROUP"

        [[ $OPTION_NUMBER -eq 5 ]] && echo "Disabling User" && DISABLE_USER="true"
        [[ $OPTION_NUMBER -eq 6 ]] && echo "Enabling User" && ENABLE_USER="true"
        for TARGET_MACHINES in "${TARGET_MACHINES[@]}"; do
            TARGET_MACHINES=$(echo "$TARGET_MACHINES" | xargs) # Trim whitespace
           # echo "${TARGET_MACHINES}"
            for USER_NAME in "${USER_ARRAY[@]}"; do
                USER_NAME=$(echo "$USER_NAME" | xargs) # Trim whitespace
                execute_ansible "-e ansible_ssh_pass='${ANSIBLE_SSH_PASS}' \
                                -e ansible_become_pass='${ANSIBLE_BECOME_PASS}' \
                                -e ANSIBLE_REMOTE_USER='${ANSIBLE_REMOTE_USER}' \
                                -e TARGET_MACHINES='${TARGET_MACHINES}' \
                                -e USER_NAME='${USER_NAME}' \
                                -e DISABLE_USER='${DISABLE_USER}' \
                                -e ENABLE_USER='${ENABLE_USER}'"
            done
        done
        success_message
        ;;
    *)
        echo "Invalid Option. Exiting."
        exit 1
        ;;
esac
