#!/bin/bash

# Define default location
weatherlocation="oslo"

function usage {
        echo 'USAGE:'
        echo "    weather [FLAGS] [LOCATION]..."
        echo
        echo 'FLAGS:'
        echo '    -h   shows this help text'
        echo '    -f   shows full weather report for 3 days'
        echo '    -m   shows moon remort'
        echo '    -d   shows weather report for today'
        echo '    -l   Setting the location'
        break
}

# Getting weather report if no args are provided
if [ $# -eq 0 ]; then
         curl http://wttr.in/$weatherlocation?0F
fi

# Define list of arguments expected in the input
while getopts "l:hfmdl" arg; do
        case $arg in
                l) weatherlocation="$OPTARG" ;;
                h) usage ;;
                f) curl -s "https://wttr.in/$weatherlocation?F" ;;
                m) curl -s "https://wttr.in/Moon?F" ;;
                d) curl -s "https://wttr.in/$weatherlocation?1F" ;;
                ?)
                echo "Invalid option: -${OPTARG}."
                echo
                usage
                break
                ;;
        esac
done
shift $((OPTIND-1))
