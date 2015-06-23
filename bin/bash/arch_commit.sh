#!/bin/sh

echo -e "\nCommitting...\n"

git add -A

git commit -m "$1"

git push

echo -e "\n"
