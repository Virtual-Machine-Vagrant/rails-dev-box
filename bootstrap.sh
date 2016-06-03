#!/usr/bin/env bash
# Bootstrap file for setting Ruby on Rails development environment

# leave empry to use current stable release or specify version, e.g. '2.3'
postgresql_version='' # '9.5'
ruby_version='' # '2.3'
rails_version='' # '4.2'

# Heper functions
function append_to_file {
  echo $1 | tee -a $2
}

function append_to_file_sudo {
  echo $1 | sudo tee -a $2
}

function install {
  echo Installing $1...
  shift
  sudo apt-get -y install "$@"
}

function return_to_home_dir {
  cd
}

function update_packages {
  echo 'Updating package information...'
  sudo apt-get -y update
}

function update_bash {
  source ~/.bashrc
}

function update_profile {
  source ~/.profile
}
# End of Heper functions

# Additional software installation
function install_git {
  sudo add-apt-repository ppa:git-core/ppa
  update_packages

  install 'Git' git
}

function install_node {
  curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
  install 'NodeJS with npm' nodejs
}

function set_node_permissions {
  echo 'Setting correct NodeJS permissions...'
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  append_to_file 'export PATH=~/.npm-global/bin:$PATH' ~/.profile
  update_profile
}

function install_node_and_set_permissions {
  install_node
  set_node_permissions
}

function install_postgresql {
  append_to_file_sudo \
    'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' \
    /etc/apt/sources.list.d/pgdg.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -
  update_packages

  install_command='postgresql'
  if [ -n "$postgresql_version" ]; then
    install_command="$install_command-$postgresql_version"
  fi
  install 'PostgreSQL' "$install_command" libpq-dev
}

function create_db_user {
  sudo -u postgres createuser -s -e vagrant
}

function install_postgresql_and_create_db_user {
  install_postgresql
  create_db_user
}
# End of Additional software installation

# Ruby installation
function install_ruby_install {
  wget -O ruby-install-0.6.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz
  tar -xzvf ruby-install-0.6.0.tar.gz
  cd ruby-install-0.6.0/
  sudo make install

  return_to_home_dir
}

function install_ruby {
  echo 'Installing Ruby...'
  install_ruby_install
  ruby-install ruby "$ruby_version"
}

function install_chruby {
  wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
  tar -xzvf chruby-0.3.9.tar.gz
  cd chruby-0.3.9/
  sudo make install

  return_to_home_dir
}

function enable_ruby_auto_switch {
  append_to_file 'source /usr/local/share/chruby/auto.sh' ~/.bashrc
}

function set_default_ruby {
  append_to_file "chruby ruby-$ruby_version" ~/.profile
  update_profile
}

function config_chruby {
  append_to_file 'source /usr/local/share/chruby/chruby.sh' ~/.bashrc
  update_bash

  set_default_ruby
  enable_ruby_auto_switch
}

function install_and_config_chruby {
  echo 'Installing chruby...'
  install_chruby
  config_chruby
}

function install_ruby_with_chruby {
  install_ruby
  install_and_config_chruby
}

function disable_ruby_doc {
  echo 'Disabling automatic Ruby documentation installation...'
  append_to_file 'gem: --no-rdoc --no-ri' ~/.gemrc
}
# End of Ruby installation

function switch_ruby_once {
  source /usr/local/share/chruby/chruby.sh
  chruby ruby-"$ruby_version"
}

function install_rails {
  echo 'Installing Rails...'

  install_command='rails'
  if [ -n "$rails_version" ]; then
    install_command="$install_command -v ~> $rails_version"
  fi
  gem install "$install_command"
}

function install_gems {
  # switch_ruby_once # Manually switch Ruby for provision run
  install_rails
}

update_packages
install_git
install_node_and_set_permissions
install_postgresql_and_create_db_user
install_ruby_with_chruby
disable_ruby_doc
install_gems

echo 'All set, rock on!'
