#!/usr/bin/env bash
# Bootstrap file for setting Ruby on Rails development environment.

ruby_version='2.3.3'
postgresql_version='9.6'

# Heper functions
function append_to_file {
  echo "$1" | sudo tee -a "$2"
}

function replace_in_file {
  sudo sed -i "$1" "$2"
}

function add_repository {
  sudo add-apt-repository "$1"
}

function install {
  echo "Installing $1..."
  shift
  sudo apt-get -y install "$@"
}

function update_packages {
  echo 'Updating package information...'
  sudo apt-get -y update
}
# End of Heper functions

# Dependencies
function install_git {
  add_repository ppa:git-core/ppa
  update_packages
  install 'Git' git
}

function install_dependencies {
  sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

  install_git
  install 'Ruby dependencies' build-essential libssl-dev libreadline-dev
}
# Enf of Dependencies

# PostgreSQL
function install_postgresql {
  append_to_file \
    'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' \
    /etc/apt/sources.list.d/pgdg.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -
  update_packages

  install 'PostgreSQL' postgresql-"$postgresql_version" libpq-dev
}

function create_vagrant_superuser {
  sudo -u postgres createuser -s ubuntu
}

function allow_external_connections {
  append_to_file \
    'host all all all password' \
    /etc/postgresql/"$postgresql_version"/main/pg_hba.conf
  replace_in_file \
    "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" \
    /etc/postgresql/"$postgresql_version"/main/postgresql.conf
}

function install_postgresql_and_allow_external_connections {
  install_postgresql
  create_vagrant_superuser
  allow_external_connections
}
# End of PostgreSQL

# NodeJS
function install_node {
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
  install 'NodeJS' nodejs
}

function set_npm_permissions {
  echo 'Setting correct Npm permissions...'
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  append_to_file 'export PATH=~/.npm-global/bin:$PATH' ~/.profile
  source ~/.profile
}

function install_node_and_npm {
  install_node
  set_npm_permissions
}
# End of NodeJS

# Ruby
function install_rbenv {
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  append_to_file 'export PATH="$HOME/.rbenv/bin:$PATH"' ~/.profile
  append_to_file 'eval "$(rbenv init -)"' ~/.profile
  source ~/.profile
}

function install_ruby_build {
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  append_to_file \
    'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' ~/.profile
  source ~/.profile
}

function install_ruby {
  install_rbenv
  install_ruby_build
  rbenv install $ruby_version
  rbenv global $ruby_version
}

function disable_ruby_doc {
  echo 'Disabling automatic Ruby documentation installation...'
  append_to_file 'gem: --no-rdoc --no-ri' ~/.gemrc
}

function install_ruby_and_disable_doc {
  install_ruby
  disable_ruby_doc
}

function install_bundler {
  echo 'Installing Bundler...'
  gem install bundler
  rbenv rehash # Make sure Bundler commands are shimmed.
}
# End of Ruby


install_dependencies
install_postgresql_and_allow_external_connections
install_node
install_ruby_and_disable_doc
install_bundler

echo 'All set, rock on!'
