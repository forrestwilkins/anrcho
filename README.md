Anrcho - An Anonymous, Open Source Social Network
======
Anrcho is an anonymous social network designed to facilitate democratic organization and consensus
building within local communities. Each post is in the form of proposal, to do some action or plan
some local event, allowing anyone to support, block, or discuss any proposal made publicly. Via
this model of consensus, anyone can begin organizing locally, securely, and on a peer to peer
basis with the members of their community.
http://anrcho.com/

Anrcho is free and open source software, as specified above by the GNU General Public License.

## Setting up Anrcho server

1. Download the package or clone the repo.
2. Install Ruby version 2.2 using RVM or the Ruby Installer
3. Install ImageMagick: `sudo apt-get install imagemagick libmagickwand-dev`
4. Install Ruby gems: `bundle install`
5. Setup the database: `bundle exec rake db:setup`
6. Run the database migrations: `bundle exec rake db:migrate`

The default database is SQLite3.

## Tools to get Involved and Collaborate

Cloud9: https://ide.c9.io/ethanwilkins/anrcho

Trello: https://trello.com/b/h48L52IW
