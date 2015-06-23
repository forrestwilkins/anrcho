#!/bin/sh

echo "\nFetching latest access log...\n"

ssh root@elheroe.net 'cp /var/log/nginx/access.log ~/ && chmod 755 ~/access.log'

echo "get access.log" | sftp root@elheroe.net

echo "\nCleaning up...\n"

ssh root@elheroe.net 'rm ~/access.log'

echo "Playing log...\n"

logstalgia -1280x720 ~/access.log