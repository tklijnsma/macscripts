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
${user}@${MAC_HOST} \
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
        ssh -p $port $user@$MAC_HOST 'ls'
        )
    }

pbcopy() {
    (
    _compile_pbcopy_ssh_command() {
        verbose_option=""
        if [ ! -z "${verbose}" ]; then
            verbose_option=" -vvv "
        fi
        command="ssh -p ${port} ${verbose_option} ${user}@${MAC_HOST} 'echo \"$string\" | pbcopy' "
        }

    _mac-cleanup

    while getopts 'p:vt' flag; do
        case "${flag}" in
            p) port="${OPTARG}" ;;
            v) verbose='-vvv' ;;
            t) testmode="true" ;;
            *) print_usage
                _mac-cleanup
                return
                ;;
            esac
        done

    # Get the rest of the arguments; this should be just one filename
    shift $((OPTIND-1))
    file=$@


    run() {
        if [ -z "${string}" ] || [ -z "${port}" ]; then
            echo "string:   ${string}"
            echo "port:     ${port}"
            print_usage
            _mac-cleanup
            return
        fi

        string=${string%$'\n'}
        _compile_pbcopy_ssh_command

        if [ "${testmode}" == "false" ]; then
            echo "${command}"
            eval "${command}"
        else
            echo "TESTMODE:"
            echo "string:      ${string}"
            echo "port:        ${port}"
            echo "command:"
            echo "${command}"
        fi

        _mac-cleanup
        }

    # Reads the stdin to variable string
    IFS='' read -r -d '' string <<"EOF"
$(< /dev/stdin)
EOF

    run
    )
    }
