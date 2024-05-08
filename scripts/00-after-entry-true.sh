#!/bin/bash

### ---
### BEGIN COPIED FROM OSPOOL SCRIPTS

glidein_config="$1"

function info {
    echo "INFO  " $@ 1>&2
}

function warn {
    echo "WARN  " $@ 1>&2
}

###########################################################
# Ensure only one copy of this script is running at the 
# same time. For example, if a mount or something hangs
# further down, we do not want more copies of this script
# to add to the problem.

export PID_FILE=00-after-entry-true.pid
if [ -e $PID_FILE ]; then
    OLD_PID=`cat $PID_FILE 2>/dev/null`
    if kill -0 $OLD_PID >/dev/null 2>&1; then
        exit 0
    fi
fi
echo $$ >$PID_FILE

#############################################################################
# At least glideinWMS 3.7.5 depends on the existence of a file named
# log/StarterLog.  However, starting in 8.9.13, this log file no longer is
# created by HTCondor.  To fix the statistics reporting, we simply create it
# here.
mkdir -p log execute
touch log/StarterLog

### END COPIED FROM OSPOOL SCRIPTS
### ---

info "I am $0"
info "I was called with flags $@"
info "I am running in $(pwd)"
info
info "$0 environment variables"
info
awk 'BEGIN { for (K in ENVIRON) { printf "%s=%s%c", K, ENVIRON[K], 0; }}' | sort -z | tr '\0' '\n' 1>&2
info
info "$0 directory contents $(pwd)"
info
ls -lah 1>&2
info
info "$0 all files under $(pwd)"
info 
find . -type f 1>&2
info
info "$0 contents of glidein_config $glidein_config"
info
cat $glidein_config 1>&2
info

### ---
### BEGIN COPIED FROM OSPOOL SCRIPTS

rm -f $PID_FILE

### END COPIED FROM OSPOOL SCRIPTS
### ---
