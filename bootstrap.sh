#!/usr/bin/env bash
# Bootstrap file for setting Ruby on Rails development environment

ruby_version='2.3'
rails_version='4.2'

function install {
  echo Installing $1...
  shift
  sudo apt-get -y install "$@"
}

function update_packages {
  echo 'Updating package information...'

  sudo apt-get -y update
}

function install_git {
  install 'Git' git
}

function set_node_permissions {
  echo 'Setting correct NodeJS permissions...'

  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  echo '' | tee -a ~/.profile # insert empty line first
  echo 'export PATH=~/.npm-global/bin:$PATH' | tee -a ~/.profile
  source ~/.profile
}

function install_node {
  curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
  install 'NodeJS with npm' nodejs

  set_node_permissions
}

function install_dependencies {
  install_git
  install_node
}

function install_rvm {
  echo 'Installing RVM...'

  install 'cUrl' curl
  \curl -sSL https://get.rvm.io | bash
  source /home/vagrant/.rvm/scripts/rvm
}

function install_ruby {
  echo 'Installing Ruby...'

  rvm install "$ruby_version"
}

function disable_ruby_doc {
  echo 'Disabling automatic Ruby documentation installation...'

  touch ~/.gemrc
  echo 'gem: --no-rdoc --no-ri' > ~/.gemrc
}

function install_rvm_with_ruby {
  install_rvm
  install_ruby
  disable_ruby_doc
}

function create_rails_gemset {
  echo 'Creating rails gemset...'

  rvm gemset create rails-"$rails_version"
  rvm use "$ruby_version"@rails-"$rails_version" --default
}

function install_rails {
  echo 'Installing Rails...'

  gem install rails -v "~> $rails_version"
}

update_packages
install_dependencies
install_rvm_with_ruby
create_rails_gemset
install_rails

echo 'All set, rock on!'
