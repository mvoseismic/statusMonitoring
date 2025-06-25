#!/usr/bin/bash
#
# tests network read and write speeds for mounted disks
#
# R.C. Stewart, 2025-06-19

disks=( /mnt/mvofls2/Seismic_Data/tmp /mnt/mvofls3/Imagery_Data/tmp /mnt/mvohvs3/MVOSeisD6/tmp )

DATADIR="/home/seisan/data/statusMonitoring/network"

for i in "${disks[@]}"
do

    echo -n `date +%s` >> "${DATADIR}/network_disks_write_speed.txt"
    echo -n " " >> "${DATADIR}/network_disks_write_speed.txt"
    echo -n "$i" >> "${DATADIR}/network_disks_write_speed.txt"
    echo -n " " >> "${DATADIR}/network_disks_write_speed.txt"
    script -O /dev/null -c 'dd if=/dev/zero of='"${i}"'/test1.img bs=128M count=1 oflag=dsync' | grep copied >> "${DATADIR}/speed/network_disks_write_speed.txt"

    echo -n `date +%s` >> "${DATADIR}/network_disks_read_speed.txt"
    echo -n " " >> "${DATADIR}/network_disks_read_speed.txt"
    echo -n "$i" >> "${DATADIR}/network_disks_read_speed.txt"
    echo -n " " >> "${DATADIR}/network_disks_read_speed.txt"
    script -O /dev/null -c 'dd if='"${i}"'/test1.img of=/dev/null bs=128M count=1 oflag=dsync' | grep copied >> "${DATADIR}/speed/network_disks_read_speed.txt"

done

