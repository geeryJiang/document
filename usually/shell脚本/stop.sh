#!/bin/bash
cd `dirname $0`
BIN_DIR=`pwd`
cd ..
DEPLOY_DIR=`pwd`
CONF_DIR=$DEPLOY_DIR/conf

SERVER_NAME=`sed '/^dubbo.application.name/!d;s/.*=//' conf/dubbo.properties | tr -d '\r'`

if [ -z "$PIDS" ]; then
	SERVER_NAME=`hostname`
fi

PIDS=`ps -ef | grep java | grep "$CONF_DIR" |awk '{print $2}'`
if [ -z "PIDS" ]; then
	echo "ERROR: The $SERVER_NAME does not started!"
	exit 1
fi

#if [ "$1" != "skip" ]; then
#	$BIN_DIR/dump.sh
#fi

echo -e "Stopping the $SERVER_NAME ...\c"
for PID in $PIDS ; do
	kill $PID > /dev/null 2>&1
	echo "kill"
done

COUNT=30
echo $COUNT
while [ $COUNT -gt 0 ]; do
	echo -e ".\c"
	sleep 1
	for PID in $PIDS ; do
		PID_EXIST=`ps -ef | grep $PID | grep java|grep -v grep`
		if [ -n "$PID_EXIST"]; then
			let "COUNT=$COUNT-1"
			echo "$COUNT"
			echo "$PID"
			break
		else
			COUNT=0
		fi
	done
done
PID_EXIST=`ps -ef | grep $PID | grep java|grep -v grep`
if [ -n "PID_EXIST" ]; then
	echo -e "again Stopping the $SERVER_NAME ...\c"
	kill -9 $PID
fi
echo $COUNT
