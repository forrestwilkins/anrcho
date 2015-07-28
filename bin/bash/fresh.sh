#!/bin/sh

ssh root@anrcho.com 'service unicorn stop && cd /home/rails && git pull && service unicorn start'