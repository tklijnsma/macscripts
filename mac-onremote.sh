_mac-print_usage() {
    printf "Incorrect usage"
    echo
    }

_mac-cleanup() {
    export application=''
    export file=''
    export file_fullpath=''
    export port="${MAC_SSH_PORT}"
    export verbose=''
    export location="${MAC_LOCATION}"
    export command=''
    export testmode="false"
    export user="${MAC_LOCALUSER}"
    OPTARG=''
    OPTIND=''
    OPTERR=''
    }

_mac-compile_ssh_command() {
    application_option=""
    if [ ! -z "${application}" ]; then
        application_option=" -a ${application} "
    fi
    verbose_option=""
    if [ ! -z "${verbose}" ]; then
        verbose_option=" -vvv "
    fi
    command="ssh \
-p ${port} ${verbose_option} \
${user}@localhost \
'source ~/.bashrc; mac-resolv -f \"${file_fullpath}\" -l ${location} ${application_option}' \
"
    }

_mac-run() {
    if [ -z "${file}" ] || [ -z "${location}" ] || [ -z "${port}" ] || [ -z "${user}" ]; then
        echo "file:     ${file}"
        echo "location: ${location}"
        echo "port:     ${port}"
        _mac-print_usage
        _mac-cleanup
        return
    fi

    # file_fullpath="$(cd "$(dirname "$file")"; pwd)/$(basename "$file")"
    # file_fullpath="$(realpath $file)"
    file_fullpath="$(readlink -f $file)"

    _mac-compile_ssh_command

    if [ "${testmode}" == "false" ]; then
        eval "${command}"
    else
        echo "TESTMODE:"
        echo "file:        ${file}"
        echo "application: ${application}"
        echo "location:    ${location}"
        echo "port:        ${port}"
        echo "command:"
        echo "${command}"
    fi

    _mac-cleanup
    }

_mac-getopts() {
    _mac-cleanup
    while getopts 'l:a:p:vt' flag; do
        case "${flag}" in
            l) location="${OPTARG}" ;;
            a) application="${OPTARG}" ;;
            p) port="${OPTARG}" ;;
            v) verbose='-vvv' ;;
            t) testmode="true" ;;
            *) _mac-print_usage
                _mac-cleanup
                return
                ;;
            esac
        done
    }

mac() {
    (
        _mac-getopts
        # Get the rest of the arguments; this should be just one filename
        shift $((OPTIND-1))
        file=$@
        _mac-run
        )
    }

mac-ls() {
    # Useful for testing connection
    (
        _mac-getopts
        ssh -p $port $user@localhost 'ls'
        )
    }
