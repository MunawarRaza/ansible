#!/bin/bash

WEBHOOK_URL="$1"
THEME_COLOR="$2"
LOCAL_DESTINATION_BASE_PATH="$3"
CURRENT_DATE="${4}"
shift 4   # remove first 3 fixed args
ENV_NAME=("$@")

echo "WEBHOOK_URL: $WEBHOOK_URL"
echo "THEME_COLOR: $THEME_COLOR"
echo "LOCAL_DESTINATION_BASE_PATH: $LOCAL_DESTINATION_BASE_PATH"
echo "CURRENT_DATE: $CURRENT_DATE"
echo "Environments:"
for env in "${ENV_NAME[@]}"; do
  echo " - $env"
done


#"${WEBHOOK_URL}" "${THEME_COLOR}" "${LOCAL_DESTINATION_BASE_PATH}" "${CURRENT_DATE}" "${ENV_NAME[@]}"