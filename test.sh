#!/usr/bin/env bash

## Test install script in container

docker run -it --rm -v "${PWD}"/install-docker.sh:/usr/src/app/install-docker.sh ubuntu bash /usr/src/app/install-docker.sh
