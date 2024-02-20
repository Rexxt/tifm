#!/bin/bash
# TIFM installer script
# run by using {sudo curl -sL https://raw.githubusercontent.com/Rexxt/tifm/master/installer.sh | bash}

# make sure git is installed
if ! type git &> /dev/null; then
    echo "git is not installed"
    exit 1
fi

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
        sudo touch /usr/local/bin/tifm
        echo "~/tifm/main.sh" > /usr/local/bin/tifm
        sudo chmod +x ~/tifm/main.sh
        sudo chmod +x /usr/local/bin/tifm
    ;;
    2)
        echo "installing to /usr/bin"
        sudo touch /usr/bin/tifm
        echo "~/tifm/main.sh" > /usr/bin/tifm
        sudo chmod +x ~/tifm/main.sh
        sudo chmod +x /usr/bin/tifm
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
