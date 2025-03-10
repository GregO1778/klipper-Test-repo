#!/usr/bin/env bash

docker build -t "creality-pad-os" .docker/

docker run -u 1000:1000 -v ./:/build  creality-pad-os