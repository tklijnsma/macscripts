string=""
port="${MAC_SSH_PORT}"
verbose=''
command=''
testmode="false"
user="klijnsma"

if [ -z "$port" ]; then
    port="2019"
fi

print_usage() {
    printf "Usage: ..."
    echo
    }

cleanup() {
    OPTARG=''
    OPTIND=''
    OPTERR=''
    }

compile_ssh_command() {
    verbose_option=""
    if [ ! -z "${verbose}" ]; then
        verbose_option=" -vvv "
    fi
    command="ssh -p ${port} ${verbose_option} ${user}@localhost 'echo \"$string\" | pbcopy' "
    }


cleanup

while getopts 'p:vt' flag; do
    case "${flag}" in
        p) port="${OPTARG}" ;;
        v) verbose='-vvv' ;;
        t) testmode="true" ;;
        *) print_usage
            cleanup
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
        cleanup
        return
    fi

    compile_ssh_command

    if [ "${testmode}" == "false" ]; then
        eval "${command}"
    else
        echo "TESTMODE:"
        echo "string:      ${string}"
        echo "port:        ${port}"
        echo "command:"
        echo "${command}"
    fi

    cleanup
    }

# Reads the stdin to variable string
IFS='' read -r -d '' string <<"EOF"
$(< /dev/stdin)
EOF

run
