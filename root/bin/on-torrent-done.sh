#!/bin/bash

# Parameters from invoker:
# TR_TORRENT_ID
# TR_TORRENT_DIR
# <others>

clone-to-staging "$TR_TORRENT_ID" "$TR_TORRENT_DIR"

filebot-wrapper auto

