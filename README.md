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

Scripts to check earthworm.

### earthworm_status.pl

* Runs the *status* command with extra output.

### getSniffwave.sh

* Runs sniffwave with outrput to a text file for later analysis.
*
## Author

Roderick Stewart, Dormant Services Ltd

rod@dormant.org

https://services.dormant.org/

## Version History

* 1.0-dev
    * Working version

## License

This project is the property of Montserrat Volcano Observatory.
