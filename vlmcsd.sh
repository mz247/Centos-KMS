#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install vlmcsd"
    exit 1
fi

clear
printf "=======================================================================\n"
printf "Install Vlmcsd  ,  Written by XuTongle \n"
printf "=======================================================================\n"
printf "For more information please visit http://www.l68.net \n"
printf "=======================================================================\n"

get_char()
{
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}

if [ "$1" == "uninstall" ]; then
    echo ""
    echo "Press any key to start uninstall Vlmcsd..."
    char=`get_char`
    echo "Uninstall vlmcsd..."
    /etc/init.d/vlmcsd stop
    /sbin/chkconfig --del vlmcsd
    rm -f /etc/init.d/vlmcsd
    rm -f /usr/local/bin/vlmcsdmulti-x64-musl-static
    echo "Uninstall Complete."
fi

if [ "$1" != "uninstall" ]; then
    echo ""
    echo "Press any key to start install Vlmcsd..."
    char=`get_char`

    if [ -s /etc/init.d/vlmcsd ]; then
        rm -f /etc/init.d/vlmcsd
    fi

    if [ -s /usr/local/bin/vlmcsdmulti-x64-musl-static ]; then
        rm -f /usr/local/bin/vlmcsdmulti-x64-musl-static
    fi

    echo "Install vlmcsd..."
    wget -c http://mirrors.tintsoft.com/software/vlmcsd/vlmcsd.server
    mv vlmcsd.server /etc/init.d/vlmcsd
    chmod 0755 /etc/init.d/vlmcsd

    wget -c http://mirrors.tintsoft.com/software/vlmcsd/vlmcsdmulti-x64-musl-static
    mv vlmcsdmulti-x64-musl-static /usr/local/bin/vlmcsdmulti-x64-musl-static
    chmod 0755 /usr/local/bin/vlmcsdmulti-x64-musl-static

    /sbin/chkconfig --add vlmcsd

    echo "Install Complete."
    echo "Starting Vlmcsd..."
    /etc/init.d/vlmcsd start
fi
