#!/bin/bash

# Run tests using virtual visual server
docker exec -t siwapp_web_1 /bin/bash xvfb-run rake spec
