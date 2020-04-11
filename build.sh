#!/bin/bash

# build viper docker

set -xe

docker build -t theshellland/viper-docker-community -f Dockerfile .
