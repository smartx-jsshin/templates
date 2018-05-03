#!/bin/bash

## Testing Parameters ##
TARGET_IP="<Target IP Address>"
TRIAL_NUM=10
QPERF_TEST_TIME=10
QPERF_LISTEN_PORT="19765"
QPERF_TEST_PORT="19766"
########################

echo "=============================================="
echo "Testing Parameters"
echo ""
echo "Target IP Address: ${TARGET_IP}"
echo "Total number of trials: ${TRIAL_NUM}"
echo "Qperf Test Time per trial: ${QPERF_TEST_TIME}"
echo "Listen Port of Qperf: ${QPERF_LISTEN_PORT}"
echo "TCP Test Port of Qperf: ${QEPRF_TEST_PORT}"
echo "=============================================="
echo ""

TOTAL_SUM_BW=0
TOTAL_SUM_LAT=0
for (( i=1; i<=${TRIAL_NUM}; i++ ))
do
	OUTPUT=`qperf -e 5 -t ${QPERF_TEST_TIME} -lp ${QPERF_LISTEN_PORT} -ip ${QPERF_TEST_PORT} ${TARGET_IP} tcp_bw tcp_lat`
	BW=`echo $OUTPUT | awk '{print $4}'`
	LAT=`echo $OUTPUT | awk '{print $9}'`
	TOTAL_SUM_BW=`echo $TOTAL_SUM_BW + $BW | bc`
	TOTAL_SUM_LAT=`echo $TOTAL_SUM_LAT + $LAT | bc`
	echo "Trial #${i} Bandwidth: $BW, Latency $LAT"
	sleep 5
done

echo ""
echo ""
echo "Average Bandwidth of ${TRIAL_NUM} trials: `echo "scale=3; ${TOTAL_SUM_BW}/${TRIAL_NUM}" | bc`"
echo "Average Latency of ${TRIAL_NUM} trials: `echo "scale=3; ${TOTAL_SUM_LAT}/${TRIAL_NUM}" | bc`"
echo ""
echo "Ping Test Finished!!"
