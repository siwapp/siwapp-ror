#!/bin/bash

# create db and run migrations
rake db:setup
rake db:migrations

# and run whatever command
exec "$@"
