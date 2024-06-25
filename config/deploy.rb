# frozen_string_literal: true

require 'uc3-ssm'

# set vars from ENV
set :deploy_to,        ENV.fetch('DEPLOY_TO', nil)       || '/dmp/apps/dmptool'
set :rails_env,        ENV.fetch('RAILS_ENV', nil)       || 'production'
set :repo_url,         ENV.fetch('REPO_URL', nil)        || 'https://github.com/cdluc3/dmptool.git'
set :branch,           ENV.fetch('BRANCH', nil)          || 'master'

# Gets the current Git tag and revision
set :version_number, `git describe --tags`
# Default environments to skip
set :bundle_without, %w[pgsql thin rollbar development test].join(':')
# We only need to keep 3 releases
set :keep_releases, 2

# Default value for linked_dirs is []
append :linked_dirs,
       '.bundle',
       'log',
       'tmp/pids',
       'tmp/cache',
       'tmp/sockets',
       'public',
       '.cache'

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :bundler do
  before :install, 'lock_x86'

  desc 'Add x86_64-linux to Gemfile platforms'
  task :lock_x86 do
    on roles(:app), wait: 1 do
      execute "cd #{release_path} && bundle lock --add-platform x86_64-linux"
    end
  end
end

namespace :deploy do
  before :compile_assets, 'deploy:retrieve_credentials'

  after :deploy, 'dmptool_assets:copy_robots'

  after :deploy, 'git:version'
  after :deploy, 'cleanup:remove_example_configs'
  after :deploy, 'deploy:chrome_install'
  after :deploy, 'deploy:font_install'

  desc 'Retrieve encrypted crendtials file from SSM ParameterStore'
  task :retrieve_credentials do
    on roles(:app), wait: 1 do
      ssm = Uc3Ssm::ConfigResolver.new
      credentials_yml_enc = ssm.parameter_for_key('credentials_yml_enc')
      master_key = ssm.parameter_for_key('master_key')
      File.write("#{release_path}/config/master.key", master_key.chomp)
      File.write("#{release_path}/config/credentials.yml.enc", credentials_yml_enc.chomp)
    end
  end

  desc 'Install Chromium for Puppeteer'
  task :chrome_install do
    on roles(:app), wait: 1 do
      unless Dir.exist?("#{release_path}/.cache/puppeteer/chrome")
        execute "cd #{release_path} && npx puppeteer browsers install chrome"
      end
    end
  end

  desc 'Install PDF Fonts for Puppeteer'
  task :font_install do
    on roles(:app), wait: 1 do
      font_dir = "/dmp/.local/share/fonts/"
      Dir.mkdir(font_dir) unless Dir.exist?(font_dir)
      execute "cp #{release_path}/app/assets/fonts/Tinos-*.ttf #{font_dir}"
      execute "cp #{release_path}/app/assets/fonts/Roboto-*.ttf #{font_dir}"
    end
  end
end
namespace :git do
  desc 'Add the version file so that we can display the git version in the footer'
  task :version do
    on roles(:app), wait: 1 do
      execute "touch #{release_path}/.version"
      execute "echo '#{fetch :version_number}' >> #{release_path}/.version"
    end
  end
end

namespace :cleanup do
  desc 'Remove all of the example config files'
  task :remove_example_configs do
    on roles(:app), wait: 1 do
      execute "rm -f #{release_path}/config/*.yml.sample"
      execute "rm -f #{release_path}/config/initializers/*.rb.example"
    end
  end
end

namespace :dmptool_assets do
  # POST ASSET COMPILATION
  # ----------------------
  desc "Clobber and then recompile assets. For some reason the Cap one can't build application.css for CssBundling"
  task :recompile do
    on roles(:app), wait: 1 do
      execute "cd #{release_path} && bin/rails assets:clobber && bin/rails assets:precompile"
    end
  end

  desc 'Copy over the robots.txt file'
  task :copy_robots do
    on roles(:app), wait: 1 do
      execute "cp -r #{release_path}/config/robots.txt #{release_path}/public/robots.txt"
    end
  end
end
