#!/bin/bash

set -ex

# WEBHOOK_URL="https://epsystemspk.webhook.office.com/webhookb2/3e656dc9-fbea-4ec7-a886-b80b81f60f7f@fa1b4296-dc5b-4f08-9606-45d98c6fb9de/IncomingWebhook/545c94738d9e467183975dae0bbc7fad/a4d2d807-342d-4cde-8991-dfda3945ccd4/V2s_mvbJ3aKkLu4F1QCJMU3cu_7gPM7X2u_6E1NDtNpsQ1"
# THEME_COLOR='#00d75f'

# CURRENT_DATE="${1}" # taking this value from main.sh
# #LOCAL_DESTINATION_BASE_PATH="${2}"
# # CURRENT_DATE=$(date +%Y%m%d)
# shift  # Remove first arg from $@
# ENV_NAME=("$@") # taking this value from main.sh
# # ENV_NAME=("dev" "qa1")

WEBHOOK_URL="$1"
THEME_COLOR="$2"
LOCAL_DESTINATION_BASE_PATH="$3"
CURRENT_DATE="${4}"
shift 4   # remove first 3 fixed args
ENV_NAME=("$@")

# echo "URL ${WEBHOOK_URL}"
# echo "${THEME_COLOR}"
# echo "${LOCAL_DESTINATION_BASE_PATH}"
# echo "${CURRENT_DATE}"
# shift
# echo "${ENV_NAME}"

get_size(){

for ENV in ${ENV_NAME[@]};do
  echo "${ENV}"
	SIZE=$(du -sh /tmp/BACKUP_CONFIGURATIONS/${CURRENT_DATE}/${ENV} |awk '{print $1}')
	TEAMS_ALERTS+="- ${ENV} (Size: ${SIZE})\n"
done
	echo "${TEAMS_ALERTS}"
}


send_alert(){
# Send alert if there are any restarted containers
if [[ -n "$TEAMS_ALERTS" ]]; then
    payload=$(cat <<EOF
{
  "title": "Configurations Backup Alert",
  "text": "The following environment configurations are backedup:",
  "themeColor": "${THEME_COLOR}",
  "sections": [
    {
      "facts": [
        {
          "name": "Date:",
          "value": "${CURRENT_DATE}"
        },
        {
          "name": "Configuration Backup Status:",
          "value": "$(echo -e "$TEAMS_ALERTS")"
        }
      ]
    }
  ]
}
EOF
)

    # Send the alert to the webhook
    echo "Sending alert to webhook"
    curl -X POST "$WEBHOOK_URL" \
        -H "Content-Type: application/json" \
        -d "$payload" 
else
    echo "Configurations not backedup."
fi

}

get_size
send_alert
