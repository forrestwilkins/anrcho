#!/bin/sh

echo "\nCopying...\n"

cd ~/Code/GitHub

rm -rf ~/Code/GitHub/anrcho

cp -r ~/Code/rails/anrcho ~/Code/GitHub

cd ~/Code/GitHub/anrcho

git init

git remote add origin https://github.com/ethanwilkins/anrcho.git

echo -e "\nCommitting...\n"

git add -A

git commit -m "$1"

git push origin master

echo -e "\n"
