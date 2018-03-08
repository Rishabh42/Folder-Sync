#!/bin/bash

# Supposed to run on rsync-host01, change rsync-host02 to rsync-host01 to make a script that is meant to run on rsync-host02.
# Change '<path_to_file>' with the path of the directory where you have created Folder-a

while true; do
  inotifywait -r -e modify,attrib,close_write,move,create,delete /<path_to_file>/Folder-a
  rsync -avz -e "ssh -i /root/rsync-key -o StrictHostKeyChecking=no“  /<path_to_file>/Folder-a root@rsync-host02:/<path_to_file>/Folder-a
done
