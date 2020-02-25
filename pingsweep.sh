#!/bin/bash
if [ -z $1 ]; then
        echo "Missing ip!"
        echo "Sytnax: ./pingsqeep.sh 192.168.1 24"
else
        subnet=$2
        if [ -z $2 ]; then
                subnet=24
        fi
        if [ $subnet -eq 16 ]; then
                for ip1 in {1..254}; do
                        for ip2 in {1..254}; do
                        ping -c1 $1.$ip1.$ip2 | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
                        done
                done
        elif [ $subnet -eq 24 ]; then
                for ip in {1..254}; do
                   ping -c1 $1.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" & done
        fi
fi
