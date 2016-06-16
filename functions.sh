#!/bin/bash

# AOSP Build bootstrap script
#
#  get AOSP sources
#

init_config() {
    . `dirname ${BASH_SOURCE}`/config.sh
}

setup_platform() {
    if [[ ${PLATFORM} = "ubuntu" ]]; then
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
    fi
}

setup_env() {
    mkdir ~/bin
    export PATH=~/bin:$PATH
  
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo
  
    sudo mkdir ${WORKING_DIRECTORY}
    sudo chown -R `whoami` ${WORKING_DIRECTORY}
    cd ${WORKING_DIRECTORY}
}

setup_git() {
    git config --global user.name ${GIT_USER_NAME}
    git config --global user.email ${GIT_USER_EMAIL}
}

setup_aosp() {
    if [[ -z ${AOSP_BRANCH_NAME} ]]; then
        repo init -u ${AOSP_MANIFEST_URL}
    else
        repo init -u ${AOSP_MANIFEST_URL} -b ${AOSP_BRANCH_NAME}
    fi
    repo sync
}

build() {
    . build/envsetup.sh
    lunch ${BUILD_LUNCH_TARGET}
    make -j${BUILD_JOBS_NUM}
}

sendtodist() {
    if [[ ${OUTPUT_DIST} == "S3" ]];
       s3cmd mb ${OUTPUT_DIST_S3_BUCKET}
       s3cmd sync ${WORKING_DIRECTORY} ${OUTPUT_DIST_S3_BUCKET}
    fi
}


