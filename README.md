# statusMonitoring

A badly-organised collection of software to monitor the performance and status of the MVO seismic monitoring system.

* Most scripts are stored on *ospproc3* in *~/src/statusMonitoring* and copied to *~/src/statusMonitoring* on other computers where necessaary.
* All scripts are normally run by *cron*.
* Data is stored on individual computers in *~/data/statusMonitoring*.
* All locally-held data is rsynced to */mnt/mvofls2/Seismic_data/monitoring_data/statusMonitoring*.

## ~/src/statusMonitoring/checks

Scripts to check various things.

### checkComputers.sh

* Reports status of various computers used in monitoring.
* Output in *~/data/statusMonitoring/computers/checkComputers.txt*.
* Runs once an hour.

### testDiskSpeeds.sh

* Tests read and write speeds for netwok disks.
* Output in *~/data/statusMonitoring/network*.
* Runs once a day.
* Plot results using *testDiskSpeeedsPlot.m*.

## ~/src/statusMonitoring/earthworm

* Scripts to check earthworm.
* Run as cronjobs on *winston1* and *winston2*.
```
# earthworm status
*/5 * * * * /home/wwsuser/src/statusMonitoring/earthworm/earthworm_status.pl > /home/wwsuser/data/statusMonitoring/earthworm/status-winston1.txt 2>&1

# earthworm sniffwave
0 0 * * * /home/wwsuser/src/statusMonitoring/src/earthworm/getSniffwave.sh > /dev/null 2&>1

@reboot /home/wwsuser/data/statusMVOmonitoring/src/earthworm/getSniffwave.sh > /dev/null 2&>1

```


### earthworm_status.pl

* Runs the *status* command for output to a text file.

### getSniffwave.sh

* Runs sniffwave with output to a text file for later analysis.

## ~/src/statusMonitoring/nmap

### nmap_chron.sh

* Script for running nmap on the MVO network.
* Needs *nmap* installed.
* Creates web page accessible in notWebobs: http://webobs.mvo.ms:8080/mvofls2/monitoring_data/status/nmap/nmap.html
* Runs once a day as a cronjob on *opsproc3*.
```
# nmap scan of 172.17.102 network
0 8 * * * /home/seisan/src/nmap/nmap_cron.sh 2>&1
```
## Author

Roderick Stewart, Dormant Services Ltd

rod@dormant.org

https://services.dormant.org/

## Version History

* 1.0-dev
    * Working version

## License

This project is the property of Montserrat Volcano Observatory.
