#!/bin/sh

# for mac only

cd ~/Code/GitHub/anrcho/

echo "\nUpdating...\n"

git fetch --all

git reset --hard origin/master

echo "\nCopying...\n"

cp -r ~/Code/GitHub/anrcho/ ~/Code/rails/anrcho/

cd ~/Code/rails/anrcho/

rm -rf .git && rm -rf .gitignore