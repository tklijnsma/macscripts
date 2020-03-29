mac(){
    # Opens exactly one file with sublime, unless it's a directory or a .pdf or image file
    if [[ -z $1 ]]; then
        echo "Pass exactly one argument"
        return 1
    elif [[ -d $1 ]]; then
        open "$1"
    elif [[ -f $1 ]]; then
        if [[ "$1" == *pdf ]] || [[ "$1" == *png ]] || [[ "$1" == *eps ]] || [[ "$1" == *jpg ]] || [[ "$1" == *jpeg ]]; then
            open "$1"
        else
            /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl "$1"
        fi
    else
        echo "\"$1\" is not a file or directory"
        return 1
    fi
    return 0
    }