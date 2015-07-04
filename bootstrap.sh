#!/usr/bin/env bash
# Bootstrap file for setting Ruby on Rails development environment

ruby_version='2.2.2'
rails_version='4.2.3'

function install {
    echo Installing $1...
    shift
    sudo apt-get -y install "$@"
}


echo 'Updating package information...'
sudo apt-get -y update


install 'Git' git
install 'dos2unix' dos2unix # to remove windows style new lines


install 'ExecJS runtime' nodejs


# Install PostgreSQL and create user 'vagrant'
sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8
install 'PostgreSQL' postgresql libpq-dev
sudo -u postgres createuser --superuser vagrant
echo 'host all all all password' | sudo tee -a /etc/postgresql/9.3/main/pg_hba.conf
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.3/main/postgresql.conf


echo 'Installing RVM and Ruby...'
install 'cUrl' curl
\curl -sSL https://get.rvm.io | bash
source /home/vagrant/.rvm/scripts/rvm
rvm install "$ruby_version"

# No need to install documentation for gems
echo 'Disabling automatic Ruby documentation installation...'
touch ~/.gemrc
echo "gem: --no-rdoc --no-ri" > ~/.gemrc

echo 'Installing Bundler...'
gem install bundler

echo 'Creating rails gemset...'
rvm gemset create rails-"$rails_version"
rvm use "$ruby_version"@rails-"$rails_version" --default

echo 'Installing Rails...'
gem install rails -v "$rails_version"


echo 'All set, rock on!'
