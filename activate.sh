export MAC_SCRIPTS_PATH="$(dirname $(realpath $BASH_SOURCE))"
source "${MAC_SCRIPTS_PATH}/mac-config.sh"
if [[ $MAC_ISREMOTE == "TRUE" ]]; then
    source "${MAC_SCRIPTS_PATH}/mac-onremote.sh"
else
    source "${MAC_SCRIPTS_PATH}/mac-openutil.sh"
    source "${MAC_SCRIPTS_PATH}/mac-localresolver.sh"
fi