#!/bin/bash

###############################################################################
# Additional variables defined from Docker environment                        #
#                                                                             #
# TR_USERNAME                                                                 #
# TR_PASSWORD                                                                 #
#                                                                             #
###############################################################################

TR_AUTH="$(head -n 1 /etc/transmission-daemon/auth.token)"

getTorrentIds()
{
    transmission-remote --auth "$TR_AUTH" -l | sed -e '1d;$d;s/^ *//' | cut -s -d " " -f1
}

# Get a list of files (it will include directory/file or similar to any depth)
getTorrentFiles()
{
    local TORRENT_ID="$1"
    transmission-remote --auth "$TR_AUTH" -t "$TORRENT_ID" --info-files | tail -n +3 | cut -c 35-
}

getTorrentInfo()
{
    local TORRENT_ID="$1"
    
    # TODO: implement caching strategy
    transmission-remote --auth "$TR_AUTH" -t "$TORRENT_ID" --info
}

getTorrentName()
{
    local TORRENT_ID="$1"
    getTorrentInfo "$TORRENT_ID" | grep 'Name:' | cut -s -d ':' -f2
}

getTorrentRatio()
{
    local TORRENT_ID="$1"
    local RATIO=$(getTorrentInfo "$TORRENT_ID" | grep 'Ratio:' | cut -s -d ':' -f2)
    if [ $RATIO != "None" ]; then
        echo $RATIO
    else
        echo "0"
    fi
}

getTorrentHash()
{
    local TORRENT_ID="$1"
    getTorrentInfo "$TORRENT_ID" | grep -E 'Hash:' | grep -Eo '[0-9a-f]{10,}'
}

removeAndDeleteTorrent()
{
    local TORRENT_ID="$1"
    transmission-remote --auth "$TR_AUTH" --torrent "$TORRENT_ID" --remove-and-delete
}

getConfigurationProperty()
{
    local propName="$1"
    grep -E "\"$propName\":" "/etc/transmission-daemon/settings.json" | \
        sed -r 's#^(\s*\"'"$propName"'\"\s*\:\s*)(\"?)(.*?)\2(\s*\,)#\3#g'
}

setConfigurationProperty()
{
    local propName="$1"
    local propValue="$2"
    sed -i -r 's#^(\s*\"'"$propName"'\"\s*\:\s*)(\"?)(.*?)\2(\s*\,)#\1\2'"$propValue"'\2\4#g' \
        "/etc/transmission-daemon/settings.json"
}

