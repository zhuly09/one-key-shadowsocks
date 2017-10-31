#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================================
#   System Required:  CentOS6.x/7 (32bit/64bit) or Ubuntu
#   Description:  Install IKEV2 VPN for CentOS and Ubuntu
#   Author: quericy
#   Intro:  https://quericy.me/blog/699
#===============================================================================================

clear
VER=1.0.0
PORT=9001
PASSWORD="FUCKGFW"

echo "#############################################################"
echo "# Install shadowsocks for CentOS6.x/7 (32bit/64bit) or Ubuntu or Debian7/8.*"
echo "#"
echo "# Author:zhuly09"
echo "#"
echo "# Version:$VER"
echo "#############################################################"

__green(){
    if [ "$__INTERACTIVE" ] ; then
        printf '\033[1;31;32m'
    fi
    printf -- "$1"
    if [ "$__INTERACTIVE" ] ; then
        printf '\033[0m'
    fi
}

__red(){
    if [ "$__INTERACTIVE" ] ; then
        printf '\033[1;31;40m'
    fi
    printf -- "$1"
    if [ "$__INTERACTIVE" ] ; then
        printf '\033[0m'
    fi
}

__yellow(){
    if [ "$__INTERACTIVE" ] ; then
        printf '\033[1;31;33m'
    fi
    printf -- "$1"
    if [ "$__INTERACTIVE" ] ; then
        printf '\033[0m'
    fi
}

# Install Shadowsocks
function install_ikev2(){
    rootness
    get_system
    yum_install
    pre_install
    setup_shadowsocks
    success_info
}

# Make sure only root can run our script
function rootness(){
if [[ $EUID -ne 0 ]]; then
   echo "Error:This script must be run as root!" 1>&2
   exit 1
fi
}


# Ubuntu or CentOS
function get_system(){
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        system_str="0"
    elif  grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        system_str="1"
    elif  grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        system_str="1"
    else
        echo "This Script must be running at the CentOS or Ubuntu or Debian!"
        exit 1
    fi
}


#install  pip
function yum_install(){
    if [ "$system_str" = "0" ]; then
    yum -y update
    yum -y install python-pip
    else
    apt-get -y update
    apt-get -y install python-pip
    fi
}

#install shadowsocks
function yum_install(){
    pip install shadowsocks
}


function pre_install(){
    echo "#############################################################"
    echo "# Install shadowsocks for CentOS6.x/7 (32bit/64bit) or Ubuntu or Debian7/8.*"
    echo "#"
    echo "# Author:zhuly09"
    echo "#"
    echo "# Version:$VER"
    echo "#############################################################"
    echo "please input the PORT of your ssserver:"
    read -p "port(default_value:${PORT}):" ss_port
    if [ "$ss_port" = "" ]; then
        ss_port=$PORT
    fi
    
    echo "please input the PASSWORD:"
    read -p "C(default value:${PASSWORD}):" ss_pwd
    if [ "$ss_pwd" = "" ]; then
        ss_pwd=$PASSWORD
    fi
    
    echo "####################################"
    echo -e "the PORT of your server: [$(__green $ss_port)]"
    echo -e "the PASSWORD of your server: [$(__green $ss_pwd)]"
    echo ""
    echo "Press any key to start...or Press Ctrl+C to cancel"
    char=`get_char`
}

# configure and install ssserver
function setup_shadowsocks(){
    ssserver -p $PORT -k $PASSWORD -m aes-256-cfb -d start
}


# echo the success info
function success_info(){
    echo "#############################################################"
    echo -e "#"
    echo -e "# [$(__green "Install Complete")]"
    echo -e "# Version:$VER"
    echo -e "# PORT:$(__green " PORT")"
    echo -e "# PassWord:$(__green " PASSWORD")"
    echo -e "#"
    echo -e "#############################################################"
    echo -e ""
}
