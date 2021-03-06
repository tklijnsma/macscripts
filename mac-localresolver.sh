#!/bin/bash

_macresolv_print_usage() {
    printf "Usage: ..."
    echo
    }

_macresolv_cleanup() {
    export application="mac"
    export location=""
    export file=""
    export testmode="false"
    export mnt_dir="${MAC_MNTDIR}"
    OPTARG=''
    OPTIND=''
    OPTERR=''
    }

_macresolv_getopts() {
    _macresolv_cleanup
    while getopts 'l:a:f:t' flag; do
        case "${flag}" in
            l) location="${OPTARG}" ;;
            a) application="${OPTARG}" ;;
            f) file="${OPTARG}" ;;
            t) testmode="true" ;;
            *) _macresolv_print_usage
                _macresolv_cleanup
                return
                ;;
            esac
        done
    echo "macbook: location = ${location}"
    echo "macbook: application = ${application}"
    echo "macbook: remote file/dir = ${file}"
    }

_macresolv_remote_to_local(){
    if [ "${location}" == "zwolle" ]; then
        file_local="${mnt_dir}/zwolle${file}"
    elif [ "${location}" == "geneve" ]; then
        file_local="${mnt_dir}/rpi${file}"
    elif [ "${location}" == "gcloud_cpu" ]; then
        file_local="${file/\/home\/thomas/${mnt_dir}/gcloud-cpu}"
    elif [ "${location}" == "gcloud_gpu" ]; then
        file_local="${file/\/home\/thomas/${mnt_dir}/gcloud-gpu}"
    elif [ "${location}" == "lpc" ]; then
        file_local="${file}"
        file_local="${file_local/\/uscms\/home\/klijnsma\/nobackup/${mnt_dir}/lpcnobackup}"
        file_local="${file_local/\/uscms_data\/d3\/klijnsma/${mnt_dir}/lpcnobackup}"
        file_local="${file_local/\/uscms_data\/d2\/klijnsma/${mnt_dir}/lpcnobackup}"
        file_local="${file_local/\/uscms\/home\/klijnsma/${mnt_dir}/lpc}"
        file_local="${file_local/\/uscms\/homes\/k\/klijnsma/${mnt_dir}/lpc}"
    elif [ "${location}" == "t3" ]; then
        file_local="${file/\/mnt\/t3nfs01\/data01\/shome\/tklijnsm/${mnt_dir}/psi}"
    elif [[ $location == gc* ]]; then
        file_local="${mnt_dir}/${location}${file}"
    elif [ "${location}" == "rpi" ]; then
        file_local="${mnt_dir}/rpi/${file}"
    else
        echo "Location ${location} has no mapping rule!"
        exit
    fi
    }

mac-resolv() {
    (
        _macresolv_getopts "$@"
        _macresolv_remote_to_local
        echo "macbook: local file/dir = ${file_local}"
        if [ "${testmode}" == "true" ]; then
            echo "$application $file_local"
        else
            $application $file_local
        fi
        )
    }
