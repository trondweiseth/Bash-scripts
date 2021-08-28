#!/bin/bash
weather() {
        function usage {
        echo "Usage: $(basename $0) [-abcd]" 2>&1
        echo '   -h   shows this help text'
        echo '   -f   shows full weather report for 3 days'
        echo '   -m   shows moon remort'
        echo '   -d   shows weather report for today'
        }

        if [[ ${#} -eq 0 ]]; then
                curl http://wttr.in/baerum?0F
        fi

        # Define list of arguments expected in the input
        optstring=":hfmd"

        while getopts ${optstring} arg; do
        case "${arg}" in
                h) usage ;;
                f) curl http://wttr.in/baerum?F ;;
                m) curl https://wttr.in/Moon?F ;;
                d) curl http://wttr.in/baerum?nF ;;

                ?)
                echo "Invalid option: -${OPTARG}."
                echo
                usage
                ;;
        esac
        done

}
