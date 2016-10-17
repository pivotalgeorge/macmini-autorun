#!/bin/sh
TINYPROXY_PATH=$HOME/workspace/tinyproxy
PROXY_EXTERNAL_PORT=9999
LOG_PATH=$HOME/workspace/macmini-autorun/logs

PATH=$PATH:/usr/local/bin:/usr/local/sbin

rm $LOG_PATH/pcfdev_script_status.log
touch $LOG_PATH/pcfdev_script_status.log

log_state() {
  echo >> $LOG_PATH/pcfdev_script_status.log
  echo $1 >> $LOG_PATH/pcfdev_script_status.log
  echo >> $LOG_PATH/pcfdev_script_status.log
}
log_error() {
  log_state "$1 start failure"
  exit 1
}

if [ ! -d $LOG_PATH ]; then
   mkdir -p $LOG_PATH
fi

sleep 30
ifconfig -a > $LOG_PATH/ifconfig.log

cf dev start 1> $LOG_PATH/pcfdev_stdout.log 2> $LOG_PATH/pcfdev_stderr.log || log_error "pcfdev"
log_state '"cf dev start" finished running'

echo >> $LOG_PATH/ifconfig.log
echo 'after running "cf dev start"' >> $LOG_PATH/ifconfig.log
ifconfig -a >> $LOG_PATH/ifconfig.log

tinyproxy -c $TINYPROXY_PATH/tinyproxy.conf 1> $LOG_PATH/tinyproxy_stdout.log 2> $LOG_PATH/tinyproxy_stderr.log || log_error "tinyproxy"
log_state 'tinyproxy daemon started'

ssh -nNTfR $PROXY_EXTERNAL_PORT:localhost:8888 pivotal@ci-admiral || log_error "ssh tunnel"
log_state "ssh tunnel opened on $PROXY_EXTERNAL_PORT"

