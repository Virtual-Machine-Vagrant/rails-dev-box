#!/usr/bin/env bash
# Print commands to create PostgreSQL db, user and grant privileges

echo 'Create PostgreSQL database:'
echo 'postgres=# CREATE DATABASE myapp;'

echo 'Create PostgreSQL user:'
echo "postgres=# CREATE USER myapp WITH PASSWORD 'password';"

echo 'Grant privileges:'
echo 'postgres=# GRANT ALL PRIVILEGES ON DATABASE myapp TO myapp;'

sudo -u postgres psql
