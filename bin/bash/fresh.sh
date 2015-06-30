#!/bin/sh

ssh root@anrcho.com 'service unicorn stop && cd /home/rails && git pull && export PATH=$PATH:/usr/local/rvm/rubies/ruby-2.2.1/bin && /home/rails/bin/rake assets:precompile RAILS_ENV=production && service unicorn start'