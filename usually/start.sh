#!/bin/bash

cd `dirname $0`
BIN_DIR=`pwd`
hostname=`hostname`

cd ..
DEPLOY_DIR=`pwd`
CONF_DIR=$DEPLOY_DIR/conf

SERVER_NAME=`sed '/^dubbo.application.name/!d;s/.*=//' conf/dubbo.properties | tr -d '\r'`
SERVER_PROTOCOL=`sed '/^dubbo.protocol.name/!d;s/.*=//' conf/dubbo.properties | tr -d '\r'`
SERVER_PORT=`sed '/^dubbo.protocol.name/!d;s/.*=//' conf/dubbo.properties | tr -d '\r'`
LOGS_FILE=`sed '/^dubbo.log4j.file/!d;s/.*=//' conf/dubbo.properties | tr -d '\r'`

if[ -z "$SERVER_NAME" ]; then
	SERVER_NAME=`hostname`
file

PIDS=`ps -ef | grep java | grep "$CONF_DIR" |awk '{print $2}'`
if [ -n "$PIDS" ];then
	echo "ERROR: The $SERVER_NAME already started!"
	echo "PID: $PIDS"
	exit 1
fi

if [ -n "$SERVER_PORT" ]; then
	SERVER_PORT_COUNT=`netstat -tln | grep $SERVER_PORT | wc -l`
	if [ $SERVER_PORT_COUNT -gt 0 ];then
		echo "ERROR: The $SERVER_NAME port $SERVER_PORT already used!"
		exit 1
	fi
fi

LOGS_DIR=""
if [ -n "$LOGS_FILE" ]; then
	LOGS_DIR=`dirname $LOGS_FILE`
else
	LOGS_DIR=$DEPLOY_DIR/logs
fi
if [ ! -d $LOGS_DIR ]; then
	mkdir -p $LOGS_DIR
fi
STDOUT_FILE=$LOGS_DIR/stdout.log

LIB_DIR=$DEPLOY_DIR/lib
LIB_JARS=`ls $LIB_DIR|grep .jar|awk '{print "'$LIB_DIR'/"$0}'|tr "\n" ":"`

JAVA_OPTS=" -Djava.awk.headless=true -Djava.net.preferIPv4Stack=true "
JAVA_DEBUG_OPTS=""

if [ "$1" = "debug" ]; then
	JAVA_DEBUG_OPTS=" -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n "
fi
#JAVA_JMX_OPTS=""
#if [ "$1" = "jmx" ]; then
	JAVA_DEBUG_OPTS=" -Dcom.sun.management.jmxremote.port=6999 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false "
#fi
JAVA_MEM_OPTS=""
BITS=`java -version 2>&1 | grep -i 64-bit`
if [ -n "$BITS" ]; then
	JAVA_MEM_OPTS=" -server -Xmx4g -Xms4g -Xmn256m -XX:PermSize=128m -Xss256k -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMetthods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 "
else
	JAVA_MEM_OPTS=" -server -Xmx1g -Xms1g -XX:permSize=128m -XX:SurvivorRatio=2 -XX:+UseParallelGC "
fi

JAVA_DISCONF_OPTS=" -Ddisconf.enable.remote.conf=true -Ddisconf.conf_server_host=127.0.0.1:80 -Ddisconf.version=1_0_0_0 -Ddisconf.app=$SERVER_NAME -Ddisconf.env=prod -Ddisconf.user_define_download_dir=./conf "
JAVA_AMQ_OPTS=" -Dorg.apache.activemq.SERIALIZABLE_PACKAGES=* "

echo $JAVA_OPTS > $LOGS_DIR/jvm.log
echo $JAVA_MEM_OPTS >> $LOGS_DIR/jvm.log
echo $JAVA_DEBUG_OPTS >> $LOGS_DIR/jvm.log
echo $JAVA_JMX_OPTS >> $LOGS_DIR/jvm.log
echo $JAVA_DISCONF_OPTS >> $LOGS_DIR/jvm.log
echo $JAVA_AMQ_OPTS >> $LOGS_DIR/jvm.log
echo

echo -e "Starting the $SERVER_NAME ...\c"
nohup java $JAVA_OPTS $JAVA_MEM_OPTS $JAVA_DEBUG_OPTS $JAVA_JMX_OPTS $JAVA_DISCONF_OPTS $JAVA_AMQ_OPTS -classpath $CONF_DIR:$LIB_JARS com.alibabadubbo.container.Main > $STDOUT_FILE 2>&1 &

COUNT=0
while [ $COUNT -lt 1 ]; do
	echo -e ".\c"
	sleep 1
	if [ -n "$SERVER_PORT" ]; then
		if [ "$SERVER_PROTOCOL" == "dubbo" ]; then
		COUNT=`echo status |nc -w 1 -z 127.0.0.1 $SERVER_PORT|grep -c succeeded`
		else
			COUNT=`netstat -an | grep $SERVER_PORT | wc -l`
		fi
	else
		COUNT=`ps -ef | grep java | grep "$DEPLOY_DIR" | awk '{print $2}' | wc -l`
	fi
	if [ $COUNT -gt 0 ]; then
		break
	fi
done

echo "ok!"
PIDS=`ps -ef | grep java | grep "$DEPLOY_DIR" | awk '{print $2}'`
echo "PID: $PIDS"
echo "STDOUT: $STDOUT_FILE"

