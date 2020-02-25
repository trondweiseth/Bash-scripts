#!/bin/bash
if [ -z $1 ]; then
        echo "Missing ip!"
        echo "Usage: ./full-nmap-report-generator.sh 192.168.1 24"
else
    ./pingsweep.sh $* > iplist.txt
    wait
    for ip in $(cat iplist.txt); do nmap -A -p- -Pn -sC -T4 $ip -oX $ip.nmapreport.xml & done
    wait
    for report in $(ls *.nmapreport.xml); do xsltproc $report -o $report.html & done
    wait
    for report in $(ls *.xml); do rm $report; done
    for link in $(ls *.xml.html); do firefox -new-tab $link; done
fi
