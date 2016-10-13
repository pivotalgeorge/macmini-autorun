#!/bin/sh
CONCOURSE_PATH=$HOME/workspace/vagrant-concourse
CONCOURSE_EXTERNAL_PORT=8000

if [ ! -d $CONCOURSE_PATH ]; then
  mkdir -p $CONCOURSE_PATH
fi

cd $CONCOURSE_PATH
if [ ! -f Vagrantfile ]; then
  brew cask install vagrant
  vagrant init concourse/lite
  sed -i -e 's/^end/end\
config.vm.network "forwarded_port", guest: 8080, host: '"$CONCOURSE_EXTERNAL_PORT"'/' Vagrantfile
fi

vagrant up
