#!/bin/sh
TINYPROXY_PATH=$HOME/workspace/tinyproxy
PROXY_EXTERNAL_PORT=9999
LOG_PATH=$HOME/workspace/macmini-autorun/logs

PATH=$PATH:/usr/local/bin

if [ ! -d $LOG_PATH ]; then
  mkdir -p $LOG_PATH
fi

sleep 30
ifconfig -a > $LOG_PATH/ifconfig.log

cf dev start 1> $LOG_PATH/pcfdev_stdout.log 2> $LOG_PATH/pcfdev_stderr.log

echo >> $LOG_PATH/pcfdev_stdout.log
echo '"cf dev start" finished running' >> $LOG_PATH/pcfdev_stdout.log

echo >> $LOG_PATH/ifconfig.log
echo 'after running "cf dev start"' >> $LOG_PATH/ifconfig.log
ifconfig -a >> $LOG_PATH/ifconfig.log

tinyproxy -c $TINYPROXY_PATH/tinyproxy.conf > $LOG_PATH/tinyproxyout.log 
ssh -nNTfR $PROXY_EXTERNAL_PORT:localhost:8888 pivotal@ci-admiral

