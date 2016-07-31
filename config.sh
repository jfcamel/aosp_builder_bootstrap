#!/bin/bash

# config.sh for AOSP builder bootstrap script

# platform id
PLATFORM="ubuntu"

# environment variables
WORKING_DIRECTORY="/mnt/WORKING_DIRECTORY"

# git variables
GIT_USER_NAME=`git config --get user.name`
GIT_USER_EMAIL=`git config --get user.email`

# AOSP variables
AOSP_BRANCH_NAME=""
AOSP_MANIFEST_URL="https://android.googlesource.com/platform/manifest"

# build target
BUILD_LUNCH_TARGET=aosp_arm64-eng
BUILD_JOBS_NUM=$((1+`cat /proc/cpuinfo | grep processor | wc -l`))

# output distination
OUTPUT_DIST="S3"
OUTPUT_DIST_S3_BUCKET="{$S3_OUTPUT_BUCKET_NAME}"


