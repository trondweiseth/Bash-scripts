# Script for non-interactive SSH login.

This script can be used to log in without having to deal with password prompt for ssh.

# Prerequisite
    Install sshpass

# Create an ecrypted password file

    PS! Remember to encrypt the password file with a strong password!

    $ cd ~/
    $ touch .psshpass
    $ vim .psshpass #Add your pss passord and save
    $ gpg -c .psshpass
    $ rm .psshpass
    
# Usage

    ./pssh.sh <host>

Or you can add an alias: alias pssh='bash $HOME/pssh.sh'

    pssh <host>
