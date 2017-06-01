#!/bin/bash

docker rm -f agms-transmission && echo x>/dev/null
docker build -t agms-transmission . && \
docker run -it \
    --name agms-transmission \
    -e "TR_USERNAME=ag" \
    -e "TR_PASSWORD=pwd" \
    -p 9091:9091 \
    -p 51413:51413 \
    -v "/media/hd-data/ag-docker-volumes/agms-transmission:/data" \
    agms-transmission

