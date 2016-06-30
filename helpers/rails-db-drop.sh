#!/usr/bin/env bash
# Drop Rails project database

echo "Dropping Rails db..."
bin/rails db:drop
