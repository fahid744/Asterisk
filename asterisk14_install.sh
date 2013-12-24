#!/bin/bash
#
# Before running this script, ensure that you have performed a Minimal CentOS Installation
# and have removed all optional packages with the exception of the following ones from the
# Base Group:
#  man-pages
#  mlocate
#  setuptool
#  symlinks
#  wget

CHOICE=-1
ASTERISK=1.4.9
ADDONS=1.4.2
LIBPRI=1.4.1
ZAPTEL=1.4.4

function displayLicense {
      echo ""
      echo "* Asterisk Installation Script v1.0, Copyright (c) 2007, David Amond"
      echo "* All rights reserved."
      echo "*"
      echo "* Redistribution and use in source and binary forms, with or without"
      echo "* modification, are permitted provided that the following conditions are met:"
      echo "*     * Redistributions of source code must retain the above copyright"
      echo "*       notice, this list of conditions and the following disclaimer."
      echo "*     * Redistributions in binary form must reproduce the above copyright"
      echo "*       notice, this list of conditions and the following disclaimer in the"
      echo "*       documentation and/or other materials provided with the distribution."
      echo "*"
      echo "* THIS SOFTWARE IS PROVIDED BY DAVID AMOND ``AS IS'' AND ANY"
      echo "* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED"
      echo "* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE"
      echo "* DISCLAIMED. IN NO EVENT SHALL DAVID AMOND BE LIABLE FOR ANY"
      echo "* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES"
      echo "* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;"
      echo "* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND"
      echo "* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT"
      echo "* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS"
      echo "* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
      echo ""
}

function displayUsage {
   echo ""
   echo "Asterisk Installation Script v1.0 (c) 2007 by David Amond"
   echo ""
   echo "OPTIONS: -l: Display full license."
   echo "         -o: Do not back up current configuration."
   echo "         -v: Accept default application versions.  Currently:"
   echo "               Asterisk:         1.4.9"
   echo "               Asterisk-Addons:  1.4.2"
   echo "               Libpri:           1.4.1"
   echo "               Zaptel:           1.4.4"
   echo "         -h: Display this help."
}

function setVersions {
   echo -n "What version of Asterisk do you want (ie: 1.4.9):"
   read ASTERISK
   echo -n "What version of Asterisk-Addons do you want (ie: 1.4.2):"
   read ADDONS
   echo -n "What version of Libpri do you want (ie: 1.4.1):"
   read LIBPRI
   echo -n "What version of Zaptel do you want (ie: 1.4.4):"
   read ZAPTEL
}

function menu {
   echo ""
   echo "Enter an installation option from below or to install multiple, but not"
   echo "all of the programs, enter the numbers for each (ie: enter 36 to install"
   echo "only Zaptel and Asterisk):"
   echo ""
   echo "  Option 1: Update boot and security configuration, Update and Install"
   echo "            additional packages, and Reboot"
   echo "  Option 2: Download and install Asterisk, Asterisk-Addons, Libpri, and Zaptel"
   echo "  Option 3: Download and install Asterisk only"
   echo "  Option 4: Download and install Asterisk-Addons only"
   echo "  Option 5: Download and install Libpri only"
   echo "  Option 6: Download and install Zaptel only"
   echo "  Option 7: Download Only Asterisk, Asterisk-Addons, Libpri, and Zaptel"
   echo "  Option 0: Exit without taking any actions"
   echo ""
   echo -n "  Selection: "

   read CHOICE
}

function backupConfig {
   cp /etc/zaptel.conf /etc/zaptel.conf.orig
   cp -r /etc/asterisk /etc/asterisk.orig
}

# Update boot configuration, Update, Install additional packages, and Reboot:
function update {
   echo "0" > /selinux/enforce
   chkconfig --levels 0123456 netfs off
   yum -y update
   yum -y install bison bison-devel gcc gcc-c++ gnutls-devel httpd kernel-devel make mysql mysql-server ncurses ncurses-devel newt-devel openssl openssl-devel patch perl php php-mysql python-devel tcl-devel zlib zlib-devel

   reboot
}

# Make a directory to hold package sources, download package sources, and extract package sources:
function download_All {
   download_Asterisk
   download_Asterisk_Addons
   download_Libpri
   download_Zaptel
}

function download_Asterisk {
   mkdir /usr/src/asterisk
   cd /usr/src/asterisk
   wget --passive-ftp ftp.digium.com/pub/asterisk/releases/asterisk-$ASTERISK.tar.gz

   tar -zxvf asterisk-$ASTERISK.tar.gz
   mv asterisk-$ASTERISK.tar.gz asterisk-$ASTERISK
   mv asterisk-$ASTERISK asterisk
}

function download_Asterisk_Addons {
   mkdir /usr/src/asterisk
   cd /usr/src/asterisk
   wget --passive-ftp ftp.digium.com/pub/asterisk/releases/asterisk-addons-$ADDONS.tar.gz

   tar -zxvf asterisk-addons-$ADDONS.tar.gz
   mv asterisk-addons-$ADDONS.tar.gz asterisk-addons-$ADDONS
   mv asterisk-addons-$ADDONS asterisk-addons
}

function download_Libpri {
   mkdir /usr/src/asterisk
   cd /usr/src/asterisk
   wget --passive-ftp ftp.digium.com/pub/libpri/releases/libpri-$LIBPRI.tar.gz

   tar -zxvf libpri-$LIBPRI.tar.gz
   mv libpri-$LIBPRI.tar.gz libpri-$LIBPRI
   mv libpri-$LIBPRI libpri
}

function download_Zaptel {
   mkdir /usr/src/asterisk
   cd /usr/src/asterisk
   wget --passive-ftp ftp.digium.com/pub/zaptel/releases/zaptel-$ZAPTEL.tar.gz

   tar -zxvf zaptel-$ZAPTEL.tar.gz
   mv zaptel-$ZAPTEL.tar.gz zaptel-$ZAPTEL
   mv zaptel-$ZAPTEL zaptel
}

function install_Asterisk {
   cd /usr/src/asterisk/asterisk

   make clean
   ./configure
   make
   make install
   make config
   make samples
}

function install_Asterisk_Addons {
   cd /usr/src/asterisk/asterisk-addons

   make clean
   ./configure
   make
   make install
}

function install_Libpri {
   cd /usr/src/asterisk/libpri

   make clean
   make
   make install
}

function install_Zaptel {
   cd /usr/src/asterisk/zaptel

   make clean
   ./configure
   make
   make config
   make zttool
   make install
}

function install_All {
   install_Libpri
   install_Zaptel
   install_Asterisk
   install_Asterisk_Addons
}

function download_install_All {
   download_All
   install_All
}

license=0
overwrite=0
versions=0

while getopts "lovh" options; do
   case $options in
      l ) displayLicense
          exit 1;;
      o ) overwrite=1;;
      v ) versions=1;;
      h ) displayUsage
          exit 1;;
   esac
done

echo ""
echo "Asterisk Installation Script v1.0 (c) 2007 by David Amond"
echo ""
echo "This program is released under a BSD license.  For the full text of"
echo "the license, rerun the program with the -l flag."
echo ""
echo "Before running this script, ensure that you have performed a Minimal"
echo "CentOS Installation and have removed all optional packages with the"
echo "exception of the following ones from the Base Group:"
echo "  man-pages"
echo "  mlocate"
echo "  setuptool"
echo "  symlinks"
echo "  wget"
echo "----------------------------------------------------------------------"

if [ "versions" ]
then
   setVersions
fi

menu

if [ "overwrite" ]
then
   backupConfig
fi

while [  $CHOICE -ne "0" ]; do
   case "$CHOICE" in
      "0")
         exit 0
         CHOICE=0;;
      "1")
         update
         CHOICE=0
         CHOICE=0;;
      "2")
         download_install_All
         CHOICE=0;;
      "3")
         download_Asterisk
         install_Asterisk
         CHOICE=0;;
      "4")
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "5")
         download_Libpri
         install_Libpri
         CHOICE=0;;
      "6")
         download_Zaptel
         install_Zaptel
         CHOICE=0;;
      "7")
         download_All
         CHOICE=0;;

      "34")
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "35")
         download_Libpri
         install_Libpri
         download_Asterisk
         install_Asterisk
         CHOICE=0;;
      "36")
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         CHOICE=0;;
      "345")
         download_Libpri
         install_Libpri
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "346")
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "354")
         download_Libpri
         install_Libpri
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "356")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         CHOICE=0;;
      "364")
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "365")
         download_Zaptel
         install_Zaptel
         download_Libpri
         install_Libpri
         download_Asterisk
         install_Asterisk
         CHOICE=0;;

      "43")
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "45")
         download_Libpri
         install_Libpri
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "46")
         download_Zaptel
         install_Zaptel
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "435")
         download_Libpri
         install_Libpri
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "436")
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "453")
         download_Libpri
         install_Libpri
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "456")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "463")
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "465")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;

      "53")
         download_Libpri
         install_Libpri
         download_Asterisk
         install_Asterisk
         CHOICE=0;;
      "54")
         download_Libpri
         install_Libpri
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "56")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         CHOICE=0;;
      "534")
         download_Libpri
         install_Libpri
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "536")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         CHOICE=0;;
      "543")
         download_Libpri
         install_Libpri
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "546")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "563")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         CHOICE=0;;
      "564")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;

      "63")
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         CHOICE=0;;
      "64")
         download_Zaptel
         install_Zaptel
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "65")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         CHOICE=0;;
      "634")
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "635")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         CHOICE=0;;
      "643")
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "645")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;
      "653")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         download_Asterisk
         install_Asterisk
         CHOICE=0;;
      "654")
         download_Libpri
         install_Libpri
         download_Zaptel
         install_Zaptel
         download_Asterisk_Addons
         install_Asterisk_Addons
         CHOICE=0;;

        *)
         echo "You have entered an invalid option..."
         echo ""
         menu
   esac
done
