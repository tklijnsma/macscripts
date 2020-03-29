#!/bin/bash
source /etc/profile
source ~/scripts/src/mac.sh

application="mac"
location=""
file=""
testmode="false"
mnt_dir="/Users/klijnsma"

print_usage() {
    printf "Usage: ..."
    echo
    }

cleanup() {
    OPTARG=''
    OPTIND=''
    OPTERR=''
    }

cleanup

while getopts 'l:a:f:t' flag; do
    case "${flag}" in
        l) location="${OPTARG}" ;;
        a) application="${OPTARG}" ;;
        f) file="${OPTARG}" ;;
        t) testmode="true" ;;
        *) print_usage
            cleanup
            return
            ;;
        esac
    done

echo "macbook: location = ${location}"
echo "macbook: application = ${application}"
echo "macbook: remote file/dir = ${file}"

remote_to_local(){
    if [ "${location}" == "zwolle" ]; then
        file_local="${mnt_dir}/mnt/zwolle${file}"
    elif [ "${location}" == "geneve" ]; then
        file_local="${mnt_dir}/mnt/rpi${file}"
    elif [ "${location}" == "gcloud_cpu" ]; then
        file_local="${file/\/home\/thomas/${mnt_dir}/mnt/gcloud-cpu}"
    elif [ "${location}" == "gcloud_gpu" ]; then
        file_local="${file/\/home\/thomas/${mnt_dir}/mnt/gcloud-gpu}"
    elif [ "${location}" == "lpc" ]; then
        file_local="${file}"
        file_local="${file_local/\/uscms\/home\/klijnsma\/nobackup/${mnt_dir}/mnt/lpcnobackup}"
        file_local="${file_local/\/uscms_data\/d3\/klijnsma/${mnt_dir}/mnt/lpcnobackup}"
        file_local="${file_local/\/uscms_data\/d2\/klijnsma/${mnt_dir}/mnt/lpcnobackup}"
        file_local="${file_local/\/uscms\/home\/klijnsma/${mnt_dir}/mnt/lpc}"
        file_local="${file_local/\/uscms\/homes\/k\/klijnsma/${mnt_dir}/mnt/lpc}"
    elif [ "${location}" == "t3" ]; then
        file_local="${file/\/mnt\/t3nfs01\/data01\/shome\/tklijnsm/${mnt_dir}/mnt/psi}"
    elif [[ $location == gc* ]]; then
        file_local="${mnt_dir}/mnt/${location}${file}"
    elif [ "${location}" == "rpi" ]; then
        file_local="${mnt_dir}/mnt/rpi/${file}"
    else
        echo "Location ${location} has no mapping rule!"
        exit
    fi
    }

remote_to_local

echo "macbook: local file/dir = ${file_local}"

if [ "${testmode}" == "true" ]; then
    echo "$application $file_local"
else
    $application $file_local
fi
