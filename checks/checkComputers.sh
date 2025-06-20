#!/bin/bash
#
# Runs various commands over ssh to check status of seismic system computers
#
# R.C. Stewart, 16-Jul-2021


# get parameter, default is 'all'
if [ $# -eq 0 ]; then
	WHAT='all'
else
	WHAT="$1"
fi


MVOFLS2='/mnt/mvofls2/Seismic_Data'


# local system
date -u
echo ''
echo ''


# winston1
matches=("all" "w1" "win1" "winston1")
if [[ "${matches[@]}" =~ "${WHAT}" ]]; then

	echo '- winston1 ---------------------------------------------------------------------------------------------'
	echo ''

	echo 'disk space'
	ssh wwsuser@172.17.102.60  df -h /dev/sda2
	echo ''

	#echo 'top'
	ssh wwsuser@172.17.102.60  top -b -n 1 | head -4
	echo ''

	echo 'uptime and last reboot'
	ssh wwsuser@172.17.102.60 last | tail -6
	echo ''
	echo ''

	echo 'winston wave server'
	ssh wwsuser@172.17.102.60 systemctl status wws | head -3
	ssh wwsuser@172.17.102.60 systemctl status importew | head -3
	echo ''

#	echo 'earthworm status'
#	ssh -tt wwsuser@172.17.102.60 'bash -l -c "source /home/wwsuser/earthworm/run_mvo/params/ew_linux.bash; /home/wwsuser/earthworm/earthworm_7.10/bin/status 2>/dev/null | tail +4 | head -n -1"' 2>/dev/null
#	echo ''

	echo 'tmp files in run_mvo/params'
	ssh wwsuser@172.17.102.60 ls -ltr /home/wwsuser/earthworm/run_mvo/params/tmp.* | tee >(wc -l) | tail -3
	echo ''

	echo 'last three continuous data files'
	ssh wwsuser@172.17.102.60 ls -ltr /home/mvo/data/rbuffers/*.msd | tail -3
	echo ''
	echo ''

fi


# mvofls2
matches=("all" "fls2" "mvofls2")
if [[ "${matches[@]}" =~ "${WHAT}" ]]; then

	echo '- mvofls2 ----------------------------------------------------------------------------------------------'
	echo ''

	echo 'last three continuous data files'
	ls -l ${MVOFLS2}/rbuffers/*.msd | tail -3
	echo ''

	echo 'last three triggered event data files'
	ls -l ${MVOFLS2}/monitoring_data/events/ | tail -3
	echo ''
	echo ''


fi

# earthworm3
matches=("all" "ew3" "earthworm3")
if [[ "${matches[@]}" =~ "${WHAT}" ]]; then

	echo '- earthworm3 -------------------------------------------------------------------------------------------'
	echo ''

	echo 'last three triggered event data files'
	ls -l /mnt/earthworm3/monitoring_data/events/ | tail -3
	echo ''


fi
