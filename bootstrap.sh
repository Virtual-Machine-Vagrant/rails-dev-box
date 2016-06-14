#!/usr/bin/env bash
# Bootstrap file for setting Ruby on Rails development environment

ruby_version='2.3.1'

# Heper functions
function append_to_file {
  echo $1 >> $2
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

function install_dependencies {
  sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8
  install 'Ruby dependencies' git build-essential libssl-dev libreadline-dev
}

function install_postgresql {
  install 'PostgreSQL' postgresql libpq-dev
}

function create_db_user {
  sudo -u postgres createuser -s vagrant
}

function install_postgresql_and_create_db_user {
  install_postgresql
  create_db_user
}

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

function create_node_symlink {
  sudo ln -s /usr/bin/nodejs /usr/bin/node
}

function install_node {
  install 'NodeJS' nodejs
  create_node_symlink
}

function install_bundler {
  echo 'Installing Bundler...'
  gem install bundler
}

update_packages
install_dependencies
install_postgresql_and_create_db_user
install_ruby_and_disable_doc
install_node
install_bundler

echo 'All set, rock on!'
