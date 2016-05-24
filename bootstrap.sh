#!/usr/bin/env bash
# Bootstrap file for setting Ruby on Rails development environment

ruby_version='2.3' # leave empty for current stable release
rails_version='5.0'
postgresql_version='9.5'

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
# End of Heper functions

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
  append_to_file '' ~/.profile # insert empty line first
  append_to_file "chruby ruby-$ruby_version" ~/.profile
}

function config_chruby {
  append_to_file '' ~/.bashrc # insert empty line first
  append_to_file 'source /usr/local/share/chruby/chruby.sh' ~/.bashrc

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

# Additional software installation
function install_git {
  install 'Git' git
}

function set_node_permissions {
  echo 'Setting correct NodeJS permissions...'
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  append_to_file '' ~/.profile # insert empty line first
  append_to_file 'export PATH=~/.npm-global/bin:$PATH' ~/.profile
}

function install_node {
  curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
  install 'NodeJS with npm' nodejs

  set_node_permissions
}

function install_postgresql {
  append_to_file_sudo \
    'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' \
    /etc/apt/sources.list.d/pgdg.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -
  update_packages

  install 'PostgreSQL' postgresql-"$postgresql_version" libpq-dev
}

function install_additional_soft {
  install_git
  install_node
  install_postgresql
}
# End of Additional software installation

function switch_ruby_once {
  source /usr/local/share/chruby/chruby.sh
  chruby ruby-"$ruby_version"
}

function install_rails {
  echo 'Installing Rails...'
  # gem install rails -v "~> $rails_version"
  gem install rails --pre
}

function install_gems {
  switch_ruby_once # Manually switch Ruby for provision run

  install_rails
}

function update_bash_and_profile {
  source ~/.bashrc
  source ~/.profile
}

update_packages
install_ruby_with_chruby
disable_ruby_doc
install_additional_soft
install_gems
update_bash_and_profile

echo 'All set, rock on!'
