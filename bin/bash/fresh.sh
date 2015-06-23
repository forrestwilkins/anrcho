#!/bin/sh

ssh root@elheroe.net 'service unicorn stop && cd /home/rails && git pull && export PATH=$PATH:/usr/local/rvm/rubies/ruby-2.1.5/bin && /home/rails/bin/bundle install && /home/rails/bin/rake assets:precompile RAILS_ENV=production && service unicorn start'