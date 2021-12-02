weather() {

        FULL=unset
        MOON=unset
        DAY=unset

        # Define default location
        weatherlocation="baerum"

        usage() {
                echo 'USAGE:'
                echo "    weather [OPTION]"
                echo
                echo 'Options:'
                echo '    -h | --help      Shows this help text'
                echo '    -f | --full      Shows full weather report for 3 days'
                echo '    -m | --moon      Shows moon remort'
                echo '    -d | --day       Shows weather report for today'
                echo '    -l | --location  Setting the location'
                break
        }

        # Getting weather report if no args are provided
        if [ $# -eq 0 ] ||  [ ]; then
            curl http://wttr.in/$weatherlocation?0F
        fi

        PARSED_ARGUMENTS=$(getopt -a -n weather -o hfmdl: --longoptions help,full,moon,day,location: -- "$@")

        # Getting weather report if no args are provided
        VALID_ARGUMENTS=$?
        if [ "$VALID_ARGUMENTS" != "0" ]; then
            curl http://wttr.in/$weatherlocation?0F
        fi

        # Define list of arguments expected in the input
        while :
        do
            case $1 in
                -l | --location) weatherlocation="$2" ; shift 2 ;;
                -h | --help) usage ; shift ;;
                -f | --full) FULL=true ; shift ;;
                -m | --moon) MOON=true ; shift ;;
                -d | --day)  DAY=true ; shift ;;
                *) break ;;
            esac
        done

        if [ $FULL = true ]; then
            curl -s "https://wttr.in/$weatherlocation?F"
        fi

        if [ $MOON = true ]; then
            curl -s "https://wttr.in/Moon?F"
        fi

        if [ $DAY = true ]; then
            curl -s "https://wttr.in/$weatherlocation?1F"
        fi
}
