Anrcho - Organize, resist, and build consensus
======
Anrcho, an anonymous social network and voting platform for the digital proletariat, designed to facilitate democratic organization and consensus building within communities. Each post is in the form of a motion or proposal, to do some action or plan some local event, enabling anyone to support, block, or discuss any given proposal with anonymity. Via this model of consensus, anyone can begin organizing locally and on a peer to peer basis with the members of their community.
https://anrcho.com/

Anrcho is free and open source software, as specified above by the GNU General Public License.

## Setting up Anrcho server

1. Download the package or clone the repo.
2. Install Ruby version 2.3.2 using RVM or the Ruby Installer
3. Install ImageMagick: `sudo apt-get install imagemagick libmagickwand-dev`
4. Install Ruby gems: `bundle install`
5. Setup the database: `bundle exec rake db:setup`
6. Run the database migrations: `bundle exec rake db:migrate`

The default database is SQLite3.

## Tools to get Involved and Collaborate

Cloud9: https://ide.c9.io/ethanwilkins/anrcho

Trello: https://trello.com/b/h48L52IW

IRC channel on Freenode: #anrcho

SEO Keywords: voting platform, constitution

## How Anrcho works

Each post is in the form of a proposal, so other users can either vote for or against it. Before a vote can be officially accounted for, it must first have an accompanying body of text explaing the reasoning or logic behind their vote, therefore enabling peer review by other users that have already been verified as human (not a bot) by Captcha. Ratification of a proposal occurs only once a certain number of supporting votes have been verified.

If, on the other hand, a vote against a proposal is ever verified, that proposal will remain in a section for revision until a new version can be ratified and brought back to the initial voting phase where official ratification is once again possible.

However, if a proposal is blocked, that vote to block can also be reversed if a majority vote is reached against it, instead of requiring any further revision, keeping a check and balance between minority and majority. This same process can actually apply to votes of support as well, enabling anyone to reverse the blocking or ratification of any given proposal.
