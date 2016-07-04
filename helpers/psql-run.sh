#!/usr/bin/env bash
# Run psql

# Use database to connect to if provided
db_arg=''
if [ -n "$1" ]; then
  db_arg="-d $1"
fi

echo 'Running psql...'
sudo -u postgres psql "$db_arg"
