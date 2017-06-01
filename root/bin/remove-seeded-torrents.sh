#!/bin/bash

# Adapted from https://raw.githubusercontent.com/martintamare/transmission-scripts/master/rm_seeded_torrent.sh

. /bin/transmission-helper.sh

main()
{
    local LIMIT_RATIO="$(getConfigurationProperty 'ratio-limit')"
    local TORRENTLIST="$(getTorrentIds)"
    
    # for each torrent in the list
    for TORRENTID in $TORRENTLIST 
    do
	    # get the ratio
	    local NAME="$(getTorrentName $TORRENTID)"
	    local RATIO="$(getTorrentRatio $TORRENTID)"
	    local STATE_STOPPED="$(getTorrentInfo $TORRENTID | grep -E 'State: Stopped|Finished|Idle')"
        
	    # if the torrent is "Stopped", "Finished", or "Idle" after seeding 100%
	    if [ $RATIO -ge $LIMIT_RATIO ] && [ "$STATE_STOPPED" != "" ]; then
		    echo "Removing torrent $TORRENTID (name=${NAME:1}; ratio=$RATIO)."
            removeAndDeleteTorrent "$TORRENTID"
	    fi
    done
}

main

