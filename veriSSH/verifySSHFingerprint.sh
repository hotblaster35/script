#!/bin/bash

tildeReplacement(){
    local file="$1"
    if [[ "$file" =~ ^~.* ]]; then
        local username=$(whoami)
        local restPath=${file#'~'}
        file="/home/${username}${restPath}"
    fi
    echo "$file"
}

if [ $# -ne 3 ] && [ $# -ne 4 ]; then
    echo "The parameters should be '-h=hostname [-p=port] -t=type -ff=fingerprintFile/-pf=publickeyFile'"
    exit 1
fi

host=""
port=""
type=""
fingerprintFile=""
publickeyFile=""

for arg in "$@"; do
    if [ -z "$host" ] && [[ "$arg" =~ ^-h=.* ]]; then
        host="${arg#-h=}"
    elif [ -z "$port" ] && [[ "$arg" =~ ^-p=.* ]]; then
        port="${arg#-p=}"
    elif [ -z "$type" ] && [[ "$arg" =~ ^-t=.* ]]; then
        type="${arg#-t=}"
    elif [ -z "$fingerprintFile" ] && [[ "$arg" =~ ^-ff=.* ]]; then 
        fingerprintFile="$(tildeReplacement "${arg#-ff=}")"
    elif [ -z "$publickeyFile" ] && [[ "$arg" =~ ^-pf=.* ]]; then
        publickeyFile="$(tildeReplacement "${arg#-pf=}")"
    fi
done

fingerprint=""
if [ -z "$fingerprintFile" ] && [ -n "$publickeyFile" ]; then
    fingerprint=$(ssh-keygen -l -f "$publickeyFile")
elif [ -n "$fingerprintFile" ]; then
    fingerprint=$(cat "$fingerprintFile")
else
    echo "No files for fingerprint or public key!"
    exit 2
fi

if [ -z "$host" ]; then
    echo "No host info!"
    exit 3
fi

if [ -z "$port" ]; then
    port=22
fi

if [ -z "$type" ]; then
    echo "No type info!"
    exit 4
fi

fpServer=$(ssh-keyscan -p "$port" -t "$type" $host | ssh-keygen -l -f -)

if [[ "$fingerprint" != "$fpServer" ]]; then
    echo "Fingerprints don't match!"
    exit 5
fi

echo "It seems it is OK to ssh ${host}."
