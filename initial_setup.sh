#!/bin/sh

die() {
  echo "died"
  exit 1
}

if [ "$1" != "concourse" -a "$1" != "pcfdev" ]; then
  echo 'initial_setup.sh should be run with one argument: [concourse|pcfdev]'
  die
fi

autorun_config="$1.plist"



sudo cp $autorun_config /Library/LaunchDaemons || die

sed -i '' "s/MACHINE_NAME=MACHINE_NAME/MACHINE_NAME=`hostname -s`/" pcfdev.sh

