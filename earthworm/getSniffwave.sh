#!/usr/bin/bash
# 
# Runs sniffwave to capture all data details
# Linux only
#
# R.C. Stewart, 2024-01-23

today=$(date -u +"%Y%m%d")
host=`hostname -s`

# Check if earthworm is running

. ./scriptVariables.txt

source /home/wwsuser/earthworm/run_mvo/params/ew_linux.bash

cd /home/wwsuser/src/statusMonitoring/src/earthworm

pkill sniffwave

nohup sniffwave WAVE_RING wild wild wild wild n >> ${dirData}/sniffwave/${today}-${host}.txt &
