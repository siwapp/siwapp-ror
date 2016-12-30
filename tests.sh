#!/bin/bash

# Run tests using virtual visual server
docker-compose exec web /bin/bash xvfb-run rspec
