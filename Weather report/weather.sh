#!/bin/bash
weather() {
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

        # Define default location
        weatherlocation="baerum"

        # Define list of arguments expected in the input
        while getopts "hfmdl:" arg; do
        case $arg in
                h) usage ;;
                f) getweather "https://wttr.in/$weatherlocation?F" ;;
                m) getweather "https://wttr.in/Moon?F" ;;
                d) getweather "https://wttr.in/$weatherlocation?1F" ;;
                l) weatherlocation="$OPTARG" ;;
                ?)
                echo "Invalid option: -${OPTARG}."
                echo
                usage
                break
                ;;
        esac
        done
        shift $((OPTIND-1))

        if [ $# -eq 0 ]; then
                getweather "http://wttr.in/$weatherlocation?0F"
        fi

        function getweather() {
                curl "$*"
        }
        unset weatherlocation
}
