application=''
file=''
file_fullpath=''
port="${MAC_SSH_PORT}"
verbose=''
location="${MAC_LOCATION}"
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
${user}@localhost 'source /Users/klijnsma/scripts/macscripts/maclocal.sh -f \"${file_fullpath}\" -l ${location} ${application_option}' \
"
    }



cleanup

while getopts 'l:a:p:vt' flag; do
    case "${flag}" in
        l) location="${OPTARG}" ;;
        a) application="${OPTARG}" ;;
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
    if [ -z "${file}" ] || [ -z "${location}" ] || [ -z "${port}" ]; then
        echo "file:     ${file}"
        echo "location: ${location}"
        echo "port:     ${port}"
        print_usage
        cleanup
        return
    fi

    file_fullpath="$(cd "$(dirname "$file")"; pwd)/$(basename "$file")"

    compile_ssh_command

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

    cleanup
    }

run
