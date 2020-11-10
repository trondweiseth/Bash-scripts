#!/bin/bash

(damsearch -LLL -x objectclass=damservicehost cn | grep -v sth | grep ^cn: | sed 's/cn: //' > "$HOME/hosts.txt" &)
export HOSTFILE="$HOME/hosts.txt"

hlookup() {
  complete -o default -A hostname hlookup
  input=$*
  host=$(echo "${input,,}")
  cat hosts.txt | egrep $host
}

vim nodelist1.csv
gethostfromcve ~/nodelist1.csv > nodelist

for h in $(cat nodelist | cut -d "." -f 1 | cut -d "." -f 1 | sed 's/.$//'); do
    hlookup $h >> clusterlist1
done

wait
cat clusterlist1 | sort | uniq > clusterlist
rm nodelist*
rm clusterlist1

bastion-ssh -l root 2> /dev/null
line1="================================"
line2="--------------------------------"
execute() {
        dszres=$(ssh -l root -o LogLevel=QUIET -o ConnectTimeout=3 -o BatchMode=yes $1 "df -h /var")

        if [ $? -eq 0 ]; then

                dsz=$(echo $dszres | grep -oe '[0-9]\.[0-9]' | sed -n 1p | cut -d "." -f1)

                if (( $dsz >= 8 )); then
                        break
                fi

                vszres=$(ssh -l root -o LogLevel=QUIET -o ConnectTimeout=3 -o BatchMode=yes $1 "vgs")
                vsz=$(echo $vszres | grep -oe '[0-9]\.[0-9]' | sed -n 2p | cut -d "." -f1)
                echo -e "\e[96m${line1}\e[0m\n\e[33m$h\e[0m\n\e[96m${line2}\e[0m"

                if (( $dsz < 8 )); then

                        ldsz=$(( 8 - $dsz ))
                        if (( $vsz < $ldsz )); then
                                lvsz=$(( $ldsz - $vsz ))
                                echo "vgs is too small: ${vsz}GB. Need to add ${lvsz}GB"
                        else
                                lvextend -rL+"$ldsz"g /dev/mapper/vg0-Var
                        fi
                fi
        else
                echo -e "\e[96m${line1}\e[0m\n\e[33mhost: $h\e[0m ssh-status: [\e[31mfailure\e[0m]\n\e[96m${line2}\e[0m"
        fi
}

for h in $(cat clusterlist); do
        execute $h | tee -a diskextention.log
done