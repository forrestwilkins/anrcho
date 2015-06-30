#!/bin/sh

echo "\nCopying...\n"

cd ~/Code/GitHub/

rm -rf anrcho/*

cp -r ~/Code/rails/anrcho/ ~/Code/GitHub/anrcho/

cd ~/Code/GitHub/anrcho

echo "Committing...\n"

git add -A

git commit -m "$1"

git push

echo "\n"
