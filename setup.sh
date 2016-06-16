#!/bin/bash

sudo apt-get update
sudo apt-get install openjdk-8-jdk

if [[ ! -e "openjdk-8-jre-headless_8u45-b14-1_amd64.deb" ]]; then
    wget http://archive.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jre-headless_8u45-b14-1_amd64.deb
    sha256sum openjdk-8-jre-headless_8u45-b14-1_amd64.deb
    sudo dpkg -i openjdk-8-jre-headless_8u45-b14-1_amd64.deb
fi
if [[ ! -e "openjdk-8-jre_8u45-b14-1_amd64.deb" ]]; then
    wget http://archive.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jre_8u45-b14-1_amd64.deb
    sha256sum openjdk-8-jre_8u45-b14-1_amd64.deb
    sudo dpkg -i openjdk-8-jre_8u45-b14-1_amd64.deb
fi
if [[ ! -e "openjdk-8-jdk_8u45-b14-1_amd64.deb" ]]; then
    wget http://archive.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jdk_8u45-b14-1_amd64.deb
    sha256sum openjdk-8-jdk_8u45-b14-1_amd64.deb
    sudo dpkg -i openjdk-8-jdk_8u45-b14-1_amd64.deb
fi

sudo apt-get -f install -y

#sudo update-alternatives --config java
#sudo update-alternatives --config javac
sudo apt-get -y install git-core gnupg flex bison gperf build-essential \
  zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
  lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
  libgl1-mesa-dev libxml2-utils xsltproc unzip
 
mkdir ~/bin
export PATH=~/bin:$PATH

curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

sudo mkdir /mnt/WORKING_DIRECTORY
sudo chown -R ubuntu /mnt/WORKING_DIRECTORY
cd /mnt/WORKING_DIRECTORY

git config --global user.name "jfcamel"
git config --global user.email "fujita.jun@gmail.com"

repo init -u https://android.googlesource.com/platform/manifest
repo sync

. build/envsetup.sh
lunch aosp_arm64-eng
make -j33

lunch aosp_flounder-userdebug
make -j33

lunch aosp_shamu-userdebug
make -j33



