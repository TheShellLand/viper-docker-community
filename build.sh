#!/bin/bash

# build viper docker

set -xe

docker build -t theshellland/viper-docker-community:v1.3-dev -f Dockerfile .
