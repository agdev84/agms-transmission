#!/bin/bash

set -e

echo "$TR_USERNAME:$TR_PASSWORD" >/etc/transmission-daemon/auth.token

. /bin/transmission-helper.sh

# Relink to files on external volumes
cp -R "/override/data/." "/data/" && rm -R "/override"

mvln "/etc/transmission-daemon/settings.json"     "/data/.transmission-daemon/settings.json"
mvln "/var/lib/transmission-daemon/info/resume"   "/data/.transmission-daemon/resume"
mvln "/var/lib/transmission-daemon/info/torrents" "/data/.transmission-daemon/torrents"

mvln "/etc/filebot-wrapper/profiles"              "/data/.filebot-wrapper/profiles"
mvln "/var/log/filebot-wrapper"                   "/data/.filebot-wrapper/log"

# Some configuration properties always need to be overwritten
# for the container to work properly
setConfigurationProperty "rpc-enabled"                  "true"
setConfigurationProperty "rpc-username"                 "$TR_USERNAME"
setConfigurationProperty "rpc-password"                 "$TR_PASSWORD"
setConfigurationProperty "rpc-port"                     "9091"
setConfigurationProperty "rpc-url"                      "/transmission/"
setConfigurationProperty "rpc-authentication-required"  "true"
setConfigurationProperty "rpc-bind-address"             "0.0.0.0"
setConfigurationProperty "script-torrent-done-enabled"  "true"
setConfigurationProperty "script-torrent-done-filename" "/bin/on-torrent-done.sh"
setConfigurationProperty "incomplete-dir-enabled"       "true"
setConfigurationProperty "incomplete-dir"               "/data/downloading"
setConfigurationProperty "download-dir"                 "/data/seeding"

# Start the services
service transmission-daemon start
service cron start

# Hang on
#/bin/bash
tail -f /var/log/dmesg

