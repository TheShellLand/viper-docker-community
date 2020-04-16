#!/bin/bash

# test viper docker

set -xe

docker run --rm -it theshellland/viper-docker-community:v1.3-dev $@
