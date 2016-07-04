#!/usr/bin/env bash
# Print commands to create PostgreSQL db, user and grant privileges

echo 'Create PostgreSQL database:'
echo 'postgres=# CREATE DATABASE app_name;'
echo ''

echo 'Create PostgreSQL user:'
echo "postgres=# CREATE USER user_name WITH PASSWORD 'password';"
echo ''

echo 'Grant privileges:'
echo 'postgres=# GRANT ALL PRIVILEGES ON DATABASE app_name TO user_name;'
echo ''

echo 'Exit psql:'
echo 'postgres=# \q'
echo ''

sudo -u postgres psql
