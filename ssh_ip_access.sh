#!/bin/sh
#grep -E '^([0-2]?[0-9]?[0-9]\.){3}([0-2]?[0-9]?[0-9])$'
#grep -q -E '^([0-2]?[0-9]?[0-9](\.|$)){4}$' <<< "$2"
regex='^([0-2]?[0-9]?[0-9](\.|$)){4}$'
subnet='(^0+\.)|(\.0+$)'
if [[ "$2" =~ $regex ]] && ! [[ "$2" =~ $subnet ]] ; then
  if iptables --line-numbers -nL INPUT  |grep  -E '[[:space:]]+ACCEPT[[:space:]]+' -- |grep -q -E "[[:space:]]+$2[[:space:]]+" -- ;then
    echo "found"
    if [[ "$1" == "-R" ]] ; then
      iptables -D INPUT -p tcp -s  $2 --dport 22 -j ACCEPT
      echo "removed"
    fi
  else
    echo "not found"
    if [[ "$2" == "-A" ]] ; then
      iptables -I INPUT -p tcp -s  $2 --dport 22 -j ACCEPT
      echo "added"
    fi
  fi
  iptables --line-numbers -nL INPUT |grep  -E '^[[:digit:]]+[[:space:]]+ACCEPT[[:space:]]+tcp' --
  #iptables --line-numbers -nL INPUT |grep  -E '^[[:digit:]]+[[:space:]]+ACCEPT[[:space:]]+tcp' --
  #iptables --line-numbers -nL INPUT 
  #getent hosts  birodb.com | awk -- '{ print $1 ; }'
else 
  echo "invalid ip value: $2"
fi
