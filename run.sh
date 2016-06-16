#!/bin/bash

# AOSP Build bootstrap script

. `dirname ${BASH_SOURCE}`/functions.sh

# load config
init_config

# setup platform
setup_platform

# setup enviroment
setup_env

# setup git
setup_git

# prepare AOSP
setup_aosp

# main process
build

# export build output
sendtodist
