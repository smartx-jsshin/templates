#!/bin/bash

## Testing Parameters ##
TARGET_IP="<TARGET_IP>"
TRIAL_NUM=10
SENDING_TIME=10
THREAD_NUM=5
########################

echo "====================================================="
echo "Testing Parameters"
echo ""
echo "Target IP Address: ${TARGET_IP}"
echo "Total number of trials: ${TRIAL_NUM}"
echo "Time Duration of Iperf in a single trial: ${SENDING_TIME}"
echo "Number of Threads sending Packets: ${THREAD_NUM}"
echo "====================================================="
echo ""

dpkg -l | grep iperf | awk '{print $2}' | grep -q "^iperf$"
if [ $? -ne 0 ]; then
	sudo apt-get -y install iperf
fi

TOTAL_SUM=0
for (( i=1; i<=${TRIAL_NUM}; i++ ))
do
	AVG_BW=`iperf -t ${SENDING_TIME} -P ${THREAD_NUM} -c ${TARGET_IP} | tail -1 | awk '{print $(NF-1)}'`
	TOTAL_SUM=`echo $TOTAL_SUM + $AVG_BW | bc`
	echo "Trial #${i} (Average Latency): $AVG_BW"
done

echo "Average Latency of ${TRIAL_NUM} trials: `echo "scale=1; ${TOTAL_SUM}/${TRIAL_NUM}" | bc`"
echo ""
echo "Iperf Test Finished"
