#!/bin/bash

HOST=$*
if [ -z $HOST ]; then
        echo "Missing hostname"
else
        gpg -d -q ~/.psshpass.gpg  > p; sshpass -f p ssh $HOST
fi
