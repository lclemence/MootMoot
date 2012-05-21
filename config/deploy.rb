set :stages, %w(staging production) 
set :default_stage, "staging" 
require 'capistrano/ext/multistage'
require "bundler/capistrano"

# set :normalize_asset_timestamps, false

role :web, "laguillotine.fr"
role :db, "laguillotine.fr"


set :application, "mootmoot"

set :keep_releases, 5
set :scm, :git
set :repository, "git@github.com:lclemence/MootMoot.git"
set :deploy_to, '/var/www/%s' % application



set :user, 'gitdeploy'
set :use_sudo, false

set :deploy_via, :copy
set :git_shallow_clone, 1
set :copy_strategy, :export

after "deploy:setup", "db:setup", "apache2:vhost"
after "deploy:update_code", "db:symlink"


# Specific options for Rails 3.1
load 'deploy/assets'
set :normalize_asset_timestamps, false

after "deploy:assets:precompile", "assets:post_release"
after "deploy:restart", "deploy:cleanup"

# Tasks for Apache Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :web, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

end

namespace :assets do
  task :post_release do

# move CSS and JS to CDN here

#    run "rm -f #{latest_release}/config/initializers/cdn_path.rb && ln -nfs #{shared_path}/config/cdn_path.rb #{latest_release}/config/initializers/cdn_path.rb"

#    run "rm -rf #{latest_release}/public/ && ln -s /var/www/fedex-frontend-#{rails_env}/current/ #{latest_release}/public"
#    run "ln -s #{shared_path}/assets #{latest_release}/public/assets"

  end
end


# Tasks for Database configuration
namespace :db do
  task :symlink do
    desc "Make symlink for the database yaml"
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"

#    desc "Make symlink for assets config file"
#    run "rm -f #{latest_release}/config/initializers/constants.rb && ln -nfs #{shared_path}/config/constants.rb #{latest_release}/config/initializers/constants.rb"
  end

  task :setup do

    template = <<-EOF
base: &base
  adapter: mysql2
  encoding: utf8
  reconnect: false
  pool: 5
  host: #{Capistrano::CLI.ui.ask "Database host: "}
  username: #{Capistrano::CLI.ui.ask "Database user: "}
  password: #{Capistrano::CLI.password_prompt "Database password: "}
  
production:
  <<: *base
  database: #{Capistrano::CLI.ui.ask "Production Database: "}

staging:
  <<: *base
  database: #{Capistrano::CLI.ui.ask "Staging Database: "}

EOF

    run "mkdir -p  #{shared_path}/config"
    put template, "#{shared_path}/config/database.yml"
  end
end

namespace :apache2 do
  task :vhost do
    desc "Generate apache2 passegener vhost configuration"
    vhost_hostname = Capistrano::CLI.ui.ask "Website hostname: " 

    template = <<-EOF
<VirtualHost *:80>
   ServerName #{vhost_hostname}
   ServerAlias #{vhost_hostname}
   DocumentRoot #{current_path}/public/
#   DefaultInitEnv RAILS_ENV production
   RackEnv #{rails_env}
   Options -MultiViews
   <Directory #{current_path}/public/>
      Options ExecCGI +FollowSymLinks
      AllowOverride all
      Order allow,deny
      Allow from all
   </Directory>
</VirtualHost>
EOF
    put template, "/etc/apache2/sites-enabled/#{application}-#{rails_env}_vhost.conf"
  end
end

