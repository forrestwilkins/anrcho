# aliases - for awesomely maximized laziness

alias cdrails='cd /home/rails'

alias railc='cdrails && rails c production'

alias logs='cdrails && vi log/production.log'

alias pull='git pull'

alias fresh_bash='source ~/.bashrc'

alias profile='nano ~/.bash_aliases'

alias rakes='rake db:migrate RAILS_ENV=production && rake assets:precompile RAILS_ENV=production'

alias unicornnn='service unicorn start'

alias killunicorn='service unicorn stop'

alias fresh='killunicorn && cdrails && pull && bundle install && rakes && unicornnn'

alias nginx_conf='nano /etc/nginx/nginx.conf'


