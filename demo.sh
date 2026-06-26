user_input(){
    echo "Getting value from source function: ${1}"
    local PROMPT="${1}"
    # echo "${PROMPT}"
    echo "Prompt value in user input function: ${PROMPT}"
    local -n INPUT_REF="${2}"
    INPUT_REF=""
    # local CHAR

    # echo -n "$PROMPT"

    while true; do
        read -p "${PROMPT}" CHAR
        read -p "You have Entered '${CHAR}'. Is this correct? (y/n): " confirmation
            if [[ "$confirmation" =~ ^[Yy]$ ]]; then
                
               # echo "Confirmed input: $CHAR"
                #INPUT_REF="$CHAR"
                echo $CHAR
                break
            else
                
                #echo "Let's try again."
                CHAR=""
            fi
    done
}

source_machine() {
    # user_input "Enter the source machine: " SOURCE_MACHINE
    SOURCE_MACHINE=$(user_input "Enter the source machine: " SOURCE_MACHINE)
    echo "${SOURCE_MACHINE}"
}
 

source_machine