#!/usr/bin/bash
#
# Runs nmap under cron to give nice HTML output
# Cron doesn't like pipes
#
# R.C. Stewart, 2021-08-06

/usr/bin/nmap 172.17.102.0-126 -oX - | /usr/bin/xsltproc -html - > /home/seisan/data/statusMonitoring/network/nmap/nmap.html
