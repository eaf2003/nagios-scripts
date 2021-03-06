##!/bin/bash
#set -x
DROPRECCHECK=1
BROCTL=/opt/bro/bin/broctl
#DROPS CRI Y WARN
CRIT=20000
WARN=100

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3



if [ $DROPRECCHECK -eq 1 ]; then
CMD1=$($BROCTL netstats | /bin/grep -v "Warning:")
   INT_REC=$(/bin/echo $CMD1 |  /bin/sed 's/[a-z]*=//g' | /usr/bin/awk '{ rec += $3 } END { printf("%d\n",rec) }')
   INT_DROP=$(/bin/echo $CMD1 | /bin/sed 's/[a-z]*=//g' | /usr/bin/awk '{ dropped += $4 } END { printf("%d\n",dropped) }')

#echo "INT_REC= $INT_REC"

#  INT_REC=$($BROCTL netstats | sed 's/[a-z]*=//g' | awk '{ recvd += $3 ; dropped += $4 } END { printf("received=%d\n",recvd) }')
#  INT_DROP=$($BROCTL netstats | sed 's/[a-z]*=//g' | awk '{ recvd += $3 ; dropped += $4 } END { printf("%d\n",dropped) }')
IDROP=$(/usr/bin/printf "%d\n" $INT_DROP 2>/dev/null)
IREC=$(/usr/bin/printf "%d\n" $INT_REC 2>/dev/null)


  if [ $INT_DROP -gt $CRIT ] ;then
    echo "CRITICAL - | REC(pkts)=$INT_REC DROP=$INT_DROP"
    exit $CRITICAL
  elif [ $INT_DROP -gt $WARN ]; then
    echo "WARNING - | REC(pkts)=$INT_REC DROP=$INT_DROP"
    exit $WARNING
  else
    echo "OK - | REC(pkts)=$INT_REC DROP=$INT_DROP" #aca $CMD1 aa $BROCTL"
    exit $OK
  fi
fi

