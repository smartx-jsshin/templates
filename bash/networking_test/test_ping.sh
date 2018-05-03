#!/bin/bash

## Testing Parameters ##
TARGET_IP="<TARGET_IP>"
TRIAL_NUM=3
PING_NUM=2
########################

echo "=============================================="
echo "Testing Parameters"
echo ""
echo "Target IP Address: ${TARGET_IP}"
echo "Testing Parameters"
echo "Total number of trials: ${TRIAL_NUM}"
echo "Number of Pings in a single trial: ${PING_NUM}"
echo "=============================================="
echo ""

dpkg -l | grep bc | awk '{print $2}' | grep -q "^bc$"
if [ $? -ne 0 ]; then
	sudo apt-get -y install bc
fi

TOTAL_SUM=0
for (( i=1; i<=${TRIAL_NUM}; i++ ))
do
	AVG_TIME=`ping -c ${PING_NUM} -W 5 -q ${TARGET_IP} | tail -1 | cut -d "/" -f5`
	TOTAL_SUM=`echo $TOTAL_SUM + $AVG_TIME | bc`
	echo "Trial #${i} (Average Latency): $AVG_TIME"
done

echo "Average Latency of ${TRIAL_NUM} trials: `echo "scale=3; ${TOTAL_SUM}/${TRIAL_NUM}" | bc`"
echo ""
echo "Ping Test Finished!!"
