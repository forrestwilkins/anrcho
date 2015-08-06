#!/bin/sh

echo "\nFetching latest access log...\n"

ssh root@anrcho.com 'cp /var/log/nginx/access.log ~/ && chmod 755 ~/access.log'

echo "get access.log" | sftp root@anrcho.com

echo "\nCleaning up...\n"

ssh root@anrcho.com 'rm ~/access.log'

echo "Playing log...\n"

logstalgia -1280x720 ~/access.log