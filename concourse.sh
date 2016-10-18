#!/bin/sh
CONCOURSE_PATH=$HOME/workspace/vagrant-concourse
CONCOURSE_EXTERNAL_PORT=8000

PATH=$PATH:/usr/local/bin

if [ ! -d $CONCOURSE_PATH ]; then
  mkdir -p $CONCOURSE_PATH
fi

cd $CONCOURSE_PATH
if [ ! -f Vagrantfile ]; then
  brew cask install vagrant
  vagrant init concourse/lite
  sed -ie 's/^end/  config.vm.network "forwarded_port", guest: 8080, host: '"$CONCOURSE_EXTERNAL_PORT"'\
end/' Vagrantfile
fi

vagrant up 1> ~/workspace/macmini-autorun/stdout.log 2> ~/workspace/macmini-autorun/stderr.log
