install() {
    (
        trap cleanup EXIT SIGSTOP SIGHUP SIGTERM ERR
        cleanup(){
            set +e
            exit
            }
        set -e pipefail

        git clone https://github.com/tklijnsma/macscripts.git
        cd macscripts
        INSTALL_DIR=$PWD
        INSTALL_LINE="source ${INSTALL_DIR}/activate.sh"
        if [ ! -f ~/.bashrc ]; then
            echo "Add the following to your shell startup:"
            echo $INSTALL_LINE
        else
            echo "Backing up and adding the following to ~/.bashrc:"
            echo $INSTALL_LINE
            cp ~/.bashrc ~/.bashrc.bu
            echo "" >> ~/.bashrc
            echo "# Automatically added by macscripts installation:" >> ~/.bashrc
            echo $INSTALL_LINE >> ~/.bashrc
        fi
        echo "Edit the following file for settings:"
        echo "${INSTALL_DIR}/mac-config.sh"
        )
    }

install
