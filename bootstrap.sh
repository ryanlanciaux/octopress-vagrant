#!/usr/bin/env bash
HOME="/home/vagrant"
PROV_FILE=.vagrant_provision.lock

#inspired by https://github.com/junwatu/nodejs-vagrant 
if [ -f $PROV_FILE ];
then
    echo "Already Provisioned"
else
    touch $PROV_FILE

    sudo apt-get install -y git make

    git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv

    # Install ruby-build
    git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build

    $HOME/.rbenv/bin/rbenv install 1.9.3-p194
    $HOME/.rbenv/bin/rbenv global 1.9.3-p194

    #Add rbenv to PATH
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.profile
    echo 'eval "$(rbenv init -)"' >> $HOME/.profile

    #own rbenv as the vagrant user
    sudo chown -Rf vagrant $HOME/.rbenv

    #don't like doing this
    sudo su - vagrant -c "rbenv rehash && cd /home/vagrant/octopress/ && gem install bundler"
    sudo su - vagrant -c "cd /home/vagrant/octopress/ && bundle install"
fi