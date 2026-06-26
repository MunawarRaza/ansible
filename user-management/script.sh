#!/bin/bash
USERS=("noor","junaid.javed","ghaffar","tayaba.tabssum","zain.tariq","awais.safdar","sarah.mushtaq","tayaba.jamil","ahmad.saeed")
#USERS=("noor","junaid.javed")
IFS=',' read -r -a USERS <<< "$USERS"
encrypted_pw=$(openssl passwd -6 "Abcd@12345")
for USERS in "${USERS[@]}"; do
	#USERS=$(echo "$USERS" | xargs) 
	echo $USERS
	sudo useradd -m -p "${encrypted_pw}" $USERS -s /bin/bash && sudo passwd -e $USERS
	#userdel -r $USERS
done
