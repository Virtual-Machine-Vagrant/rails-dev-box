# rails-dev-box
A Vagrant powered virtual machine for Ruby on Rails application development

## Requirements

* [VirtualBox](https://www.virtualbox.org)

* [Vagrant](http://vagrantup.com)

## Recommended software

* [Vagrant-vbguest plugin](https://github.com/dotless-de/vagrant-vbguest)

## How To Build The Virtual Machine

Building the virtual machine is this easy:

    host $ git clone https://github.com/skanukov/rails-dev-box
    host $ cd rails-dev-box
    host $ vagrant up

That's it.

After the installation has finished, you can access the virtual machine with

    host $ vagrant ssh

Port 3000 in the host computer is forwarded to port 3000 in the virtual machine. Thus, applications running in the virtual machine can be accessed via localhost:3000 in the host computer. Be sure the web server is bound to the IP 0.0.0.0, instead of 127.0.0.1, so it can access all interfaces:

    $ rails server -b 0.0.0.0

Don't forget to look at some helper shell scripts for newbies.

## Install recommended software

Install vagrant-vbguest plugin:

    host $ vagrant plugin install vagrant-vbguest

## What's In The Box

* Current stable Ruby with chruby and disabled automatic documentation installation

* Current stable Rails

* Current stable PostgreSQL with 'vagrant' superuser

* Current stable Git

* Current stable NodeJS v4 LTS with Npm

## License

Released under the MIT License, Copyright (c) 2015-2016 Sergey Kanukov, inspired by official [Rails dev box](https://github.com/rails/rails-dev-box).
