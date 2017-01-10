#!/bin/bash

# Run tests using virtual visual server
# Usage:
#   ./tests.sh
#   ./tests.sh spec/features/invoices/create_spec.rb
#   ./tests.sh spec/features/invoices/*.rb
docker-compose exec web xvfb-run rspec "$@"
