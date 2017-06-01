#!/bin/bash

docker rmi "agdev84/agms-transmission" && \
docker build -t myimage:tag 
docker build -t agms-transmission "agdev84/agms-transmission" && \
docker run -it \
    --name agms-transmission \
    -e "TR_USERNAME=transmission" \
    -e "TR_PASSWORD=password1" \
    -p 9091:9091 \
    -p 51413:51413 \
    -v "/media/hd-data/ag-docker-volumes/agms-transmission:/data" \
    "agdev84/agms-transmission"

