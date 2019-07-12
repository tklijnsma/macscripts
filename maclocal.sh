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
    fi
    }

remote_to_local

echo "macbook: local file/dir = ${file_local}"

if [ "${testmode}" == "true" ]; then
    echo "$application $file_local"
else
    $application $file_local
fi
