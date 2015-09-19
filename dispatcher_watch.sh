#!/bin/bash
# Author: Doug Smith <info@laboratoryb.org>
# ---------------------------------------------------------
# For Kamailio.
# This watches for the dispatcher list to be updated
# ...and then reloads the dispatcher in Kamailio.

while true; do
  change=$(inotifywait -e close_write,moved_to,create   /usr/local/etc/kamailio/)
  # change=${change#/etc/kamailio * }
  if [[ $change =~ 'dispatcher.list' ]]; then
  	echo "------------------------ dispatcher reloading"
    /usr/local/sbin/kamcmd dispatcher.reload;
    /usr/local/sbin/kamcmd dispatcher.list;
    echo "------------------------ end reloading"
  fi
done
