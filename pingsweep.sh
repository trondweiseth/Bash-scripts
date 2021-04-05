#!/bin/zsh

	trap ctrl_c SIGTERM
	ctrl_c() {
		exit
	}

	if [ -z $1 ]; then
		echo "Missing ip!"
		echo "Sytnax: [pingsweep 192.168.1.1 24] [pingsweep 192.168.1.1 16]"
	else

		if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then

			subnet=$2
			if [ -z $2 ]; then
				subnet=24
			fi

			startip=$(echo $1 | cut -d "." -f 4)
			baseip24=$(echo $1 | grep -E -o "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
			baseip16=$(echo $1 | grep -E -o "^[0-9]{1,3}\.[0-9]{1,3}")

			if [ $subnet -eq 16 ]; then
					
					startip=$(echo $1 | cut -d "." -f 3)
					for ip1 in {$startip..254}; do 
						(for ip2 in {1..254}; do (ping -c1 $baseip16.$ip1.$ip2 | grep "64 bytes" | awk '{print $4}' | tr -d ":" &) ;done &)
						wait
						sleep 2
				done

			elif [ $subnet -eq 24 ]; then
					
					startip=$(echo $1 | cut -d "." -f 4)
					for ip in {$startip..254}; do
						(ping -c 1 $baseip24.$ip | grep '64 bytes' | awk '{print $4}' | tr -d ":" &)
					done
			fi
		else
			echo "Invalid IP! Format: 0.0.0.0"
		fi
	fi
