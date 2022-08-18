#!/bin/bash
# TIFM installer script
# run by using {sudo curl -sL https://raw.githubusercontent.com/Rexxt/tifm/master/installer.sh | bash}

# make sure git is installed
if ! type git &> /dev/null; then
    echo "git is not installed"
    exit 1
fi
# make sure we're in sudo
# if [ "$EUID" -ne 0 ]; then
#     echo "please run as root"
#     exit 1
# fi

git clone "https://github.com/Rexxt/tifm.git"
rm tifm/installer.sh
mkdir -p ~/tifm
mv tifm ~
echo "where should we install tifm?"
echo "1) /usr/local/bin"
echo "2) /usr/bin"
read -p "> " -n 1 -r reply
echo
case "$reply" in
    1)
        echo "installing to /usr/local/bin"
        touch /usr/local/bin/tifm
        echo "chmod +x ~/tifm/main.sh; ~/tifm/main.sh" > /usr/local/bin/tifm
        chmod +x /usr/local/bin/tifm
    ;;
    2)
        echo "installing to /usr/bin"
        touch /usr/bin/tifm
        echo "chmod +x ~/tifm/main.sh; ~/tifm/main.sh" > /usr/bin/tifm
        chmod +x /usr/bin/tifm
    ;;
    *)
        echo "invalid option"
        exit 1
    ;;
esac
# check if tifm command is in path
if ! type tifm &> /dev/null; then
    echo "tifm is not in path... this is most likely a problem on our side."
    exit 1
else
    echo "tifm is installed and usable!"
fi