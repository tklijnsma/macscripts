#!/bin/bash
source /etc/profile

application="open"
location=""
file=""
testmode="false"

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
        file_local="/Users/thomas/mnt/zwolle${file}"
    elif [ "${location}" == "geneve" ]; then
        file_local="/Users/thomas/mnt/rpi${file}"
    elif [ "${location}" == "gcloud_cpu" ]; then
        file_local="${file/\/home\/thomas//Users/thomas/mnt/gcloud-cpu}"
    elif [ "${location}" == "gcloud_gpu" ]; then
        file_local="${file/\/home\/thomas//Users/thomas/mnt/gcloud-gpu}"
    elif [ "${location}" == "lpc" ]; then
        file_local="${file/\/uscms\/home\/klijnsma//Users/thomas/mnt/lpc}"
    elif [ "${location}" == "t3" ]; then
        file_local="${file/\/mnt\/t3nfs01\/data01\/shome\/tklijnsm//Users/thomas/mnt/psi}"
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
