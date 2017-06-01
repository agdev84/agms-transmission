#!/bin/bash

docker rm -f agms-transmission && echo x>/dev/null
#docker build -t agms-transmission . && \
docker run -it \
    --name agms-transmission \
    -e "TR_USERNAME=transmission" \
    -e "TR_PASSWORD=password" \
    -p 9091:9091 \
    -p 51413:51413 \
    -v "/media/hd-data/ag-docker-volumes/agms-transmission:/data" \
    "agdev84/agms-transmission"

