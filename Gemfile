# frozen_string_literal: true

source 'https://rubygems.org'

ruby '>= 3.0'

# ===========#
# CORE RAILS #
# ===========#

# Full-stack web application framework. (http://rubyonrails.org)
gem 'rails', '~> 6.1'

# TODO: Remove this once Rails addresses the issue with its dependency on mimemagic. Mimemagic had
#       an MIT license but was using some incompatible GPL license code.
#       Versions of mimemagic that were yanked: https://rubygems.org/gems/mimemagic/versions
#       Analysis of the issue: https://www.theregister.com/2021/03/25/ruby_rails_code/
gem 'mimemagic'

# Use Puma as the app server
gem 'puma', group: :puma, require: false

# Use esbuild, rollup.js, or Webpack to bundle your JavaScript, then deliver it via the asset pipeline in Rails
# Read more: https://github.com/rails/jsbundling-rails
gem 'jsbundling-rails'

# Use Tailwind CSS, Bootstrap, Bulma, PostCSS, or Dart Sass to bundle and process your CSS
# Read more: https://github.com/rails/cssbundling-rails
gem 'cssbundling-rails'

# Turbo gives you the speed of a single-page web application without having to write any JavaScript..
# Read more: https://github.com/hotwired/turbo-rails
#            https://github.com/hotwired/turbo-rails/blob/main/UPGRADING.md
gem 'turbo-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"
# Use Active Model has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Use Resque to manage the ActiveJob queue
# gem 'resque'

# Use Active Storage variant
# gem "image_processing", "~> 1.2"

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# GEMS ADDED TO HELP HANDLE RAILS MIGRATION FROM 3.x to 4.2
# THESE GEMS HELP SUPPORT DEPRACATED FUNCTIONALITY AND WILL LOSE SUPPORT IN
# FUTURE VERSIONS WE SHOULD CONSIDER BRINGING THE CODE UP TO DATE INSTEAD

# A set of Rails responders to dry up your application
# (http://github.com/plataformatec/responders)
# gem "responders"

# ============= #
# CONFIGURATION #
# ============= #

# Anyway Config is a configuration library for Ruby gems and applications.
gem 'anyway_config'

# Our homegrown artisinal SSM gem
gem 'uc3-ssm', git: 'https://github.com/CDLUC3/uc3-ssm' #, branch: 'ruby3.0'

# ============== #
# ERROR HANDLING #
# ============== #

# Rollbar-gem is the SDK for Ruby apps and includes support for apps using
# Rails, Sinatra, Rack, plain Ruby, and other frameworks.
# https://github.com/rollbar/rollbar-gem
gem 'rollbar', group: :rollbar, require: false

# ======== #
# DATABASE #
# ======== #

# A simple, fast Mysql library for Ruby, binding to libmysql
# (http://github.com/brianmario/mysql2)
gem 'mysql2', group: :mysql, require: false

# Pg is the Ruby interface to the {PostgreSQL
# RDBMS}[http://www.postgresql.org/](https://bitbucket.org/ged/ruby-pg)
gem 'pg', group: :pgsql, require: false

# Bit fields for ActiveRecord (https://github.com/pboling/flag_shih_tzu)
gem 'flag_shih_tzu' # , "~> 0.3.23"

# ======== #
# SECURITY #
# ======== #

# Flexible authentication solution for Rails with Warden
# (https://github.com/plataformatec/devise)
gem 'devise'

# An invitation strategy for Devise (https://github.com/scambra/devise_invitable)
# gem "devise_invitable"

# A generalized Rack framework for multiple-provider authentication.
# (https://github.com/omniauth/omniauth)
gem 'omniauth'

# OmniAuth Shibboleth strategies for OmniAuth 1.x
# https://github.com/toyokazu/omniauth-shibboleth
gem 'omniauth-shibboleth'

# ORCID OAuth 2.0 Strategy for OmniAuth 1.0
# (https://github.com/datacite/omniauth-orcid)
gem 'omniauth-orcid'

# This gem provides a mitigation against CVE-2015-9284 (Cross-Site Request
# Forgery on the request phase when using OmniAuth gem with a Ruby on Rails
# application) by implementing a CSRF token verifier that directly uses
# ActionController::RequestForgeryProtection code from Rails.
#   https://nvd.nist.gov/vuln/detail/CVE-2015-9284
gem 'omniauth-rails_csrf_protection'

# Doorkeeper is a gem (Rails engine) that makes it easy to introduce OAuth 2 provider functionality
# to your Ruby on Rails or Grape application. https://github.com/doorkeeper-gem/doorkeeper
gem 'doorkeeper'

# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
# https://github.com/jwt/ruby-jwt
gem 'jwt'

# Gems for repository integration
# OO authorization for Rails (https://github.com/elabs/pundit)
gem 'pundit'

# Gem for throttling malicious attacks
gem 'rack-attack', '~> 6.6', '>= 6.6.1'

# Support for Cross-Origin Resource Sharing (CORS) for Rack compatible web applications.
# https://github.com/cyu/rack-cors
# We are using to support development of React UI from a local developer machine.
gem 'rack-cors'

# ========== #
# UI / VIEWS #
# ========== #

# Ruby gem to handle settings for ActiveRecord instances by storing them as
# serialized Hash in a separate database table. Namespaces and defaults
# included. (https://github.com/ledermann/rails-settings)
gem 'ledermann-rails-settings'

# Gem providing simple Contact Us functionality with a Rails 3+ Engine.
# (https://github.com/jdutil/contact_us)
gem 'contact_us' # COULD BE EASILY REPLACED WITH OUR OWN CODE

# Helpers for the reCAPTCHA API (http://github.com/ambethia/recaptcha)
gem 'recaptcha'

# Ideal gem for handling attachments in Rails, Sinatra and Rack applications.
# (http://github.com/markevans/dragonfly)
gem 'dragonfly'

# Really Simple Syndication (RSS) is a family of formats that describe feeds, specially
# constructed XML documents that allow an interested person to subscribe and receive updates
# from a particular web service (https://github.com/ruby/rss)
gem 'rss'

group :aws do
  # Amazon AWS S3 data store for use with the Dragonfly gem.
  gem 'dragonfly-s3_data_store'

  gem "aws-sdk-s3"
end

# A collection of text algorithms (http://github.com/threedaymonk/text)
gem 'text', require: false

# ========== #
# PAGINATION #
# ========== #

# A pagination engine plugin for Rails 4+ and other modern frameworks
# (https://github.com/kaminari/kaminari)
gem 'kaminari'

# Paginate in your headers, not in your response body. This follows the
# proposed RFC-8288 standard for Web linking.
# https://github.com/davidcelis/api-pagination
gem 'api-pagination'

# =========== #
# STYLESHEETS #
# =========== #

# Parse CSS and add vendor prefixes to CSS rules using values from the Can
# I Use website. (https://github.com/ai/autoprefixer-rails)
gem 'autoprefixer-rails'

# ========= #
# EXPORTING #
# ========= #

# Provides binaries for WKHTMLTOPDF project in an easily accessible package.
gem 'wkhtmltopdf-binary'

# PDF generator (from HTML) gem for Ruby on Rails
# (https://github.com/mileszs/wicked_pdf)
gem 'wicked_pdf'

# This simple gem allows you to create MS Word docx documents from simple
# html documents. This makes it easy to create dynamic reports and forms
# that can be downloaded by your users as simple MS Word docx files.
# (http://github.com/karnov/htmltoword)
gem 'htmltoword'

# ==================== #
# INTERNATIONALIZATION #
# ==================== #

gem 'translation'

# ========= #
# UTILITIES #
# ========= #

# Run any code in parallel Processes(> use all CPUs) or Threads(> speedup
# blocking operations). Best suited for map-reduce or e.g. parallel downloads/uploads.
# TODO: Replace use of this with ActiveJob where possible
gem 'parallel'

# Makes http fun again! Wrapper to simplify the native Net::HTTP libraries
gem 'httparty'

# Autoload dotenv in Rails. (https://github.com/bkeepers/dotenv)
gem 'dotenv-rails'

# A library that retrieves an citation for the specified DOI.
# https://github.com/CDLUC3/uc3-citation
gem 'uc3-citation'

# Makes it easy to validate JSON attributes against a JSON schema.
gem 'activerecord_json_validator'

# Filename sanitization for Ruby. This is useful when you generate filenames for downloads from
# user input (we're using it for PDF invoice downloads in Noko). (https://github.com/madrobby/zaru)
gem 'zaru'

# We need to freeze the mail gem version as the recently released 2.8.0 triggers an exception
# We will need to check if it's fixed when we migrate to Ruby 3.0/3.1
# See : https://github.com/DMPRoadmap/roadmap/issues/3254
gem 'mail', '2.7.1'

# Delayed::Job (or DJ) encapsulates the common pattern of asynchronously executing longer tasks in the background.
# See: https://github.com/collectiveidea/delayed_job#active-job
gem 'delayed_job_active_record'

# Daemons provides an easy way to wrap existing ruby scripts (for example a self-written server) to be run as a
# daemon and to be controlled by simple start/stop/restart commands.
# See: https://rubygems.org/gems/daemons/versions/1.4.1
gem 'daemons'

# If you are using active_storage gem and you want to add simple validations for it, like presence or
# content_type you need to write a custom validation method.
#
# This gems doing it for you. Just use attached: true or content_type: 'image/png' validation.
# See: https://github.com/igorkasyanchuk/active_storage_validations
gem 'active_storage_validations'

# ================================= #
# ENVIRONMENT SPECIFIC DEPENDENCIES #
# ================================= #
group :ci, :development do
  gem 'sassc'

  # Security vulnerability scanner for Ruby on Rails.
  # (http://brakemanscanner.org)
  gem 'brakeman'

  # Helper gem to require bundler-audit
  # (http://github.com/stewartmckee/bundle-audit)
  gem 'bundle-audit'

  gem 'capistrano'

  gem 'capistrano-git-with-submodules'

  gem 'capistrano-rails'

  # RuboCop is a Ruby code style checking and code formatting tool. It aims to enforce
  # the community-driven Ruby Style Guide.
  gem 'rubocop'

  # RuboCop rules for detecting and autocorrecting undecorated strings for i18n
  # (gettext and rails-i18n)
  gem 'rubocop-i18n'

  # A collection of RuboCop cops to check for performance optimizations in Ruby code.
  # gem 'rubocop-performance'

  # Automatic Rails code style checking tool. A RuboCop extension focused on enforcing
  # Rails best practices and coding conventions.
  gem 'rubocop-rails'

  # A RuboCop plugin for Rake tasks
  # gem 'rubocop-rake'

  # Code style checking for RSpec files. A plugin for the RuboCop code style enforcing
  # & linting tool.
  gem 'rubocop-rspec'

  # Thread-safety checks via static analysis. A plugin for the RuboCop code style
  # enforcing & linting tool.
  # gem 'rubocop-thread_safety'

  # Performance checks by Rubocop
  gem 'rubocop-performance', require: false
end

group :test do
  # RSpec for Rails (https://github.com/rspec/rspec-rails)
  gem 'rspec-rails'

  # factory_bot_rails provides integration between factory_bot and rails 3
  # or newer (http://github.com/thoughtbot/factory_bot_rails)
  gem 'factory_bot_rails'

  # Easily generate fake data (https://github.com/stympy/faker)
  gem 'faker'

  # the instafailing RSpec progress bar formatter
  # (https://github.com/thekompanee/fuubar)
  gem 'fuubar'

  # Guard keeps an eye on your file modifications (https://github.com/guard/guard)
  gem 'guard'

  # Guard gem for RSpec (https://github.com/guard/guard-rspec)
  # gem 'guard-rspec'

  # Library for stubbing HTTP requests in Ruby.
  # (http://github.com/bblimke/webmock)
  gem 'webmock'

  # Strategies for cleaning databases.  Can be used to ensure a clean state
  # for testing. (http://github.com/DatabaseCleaner/database_cleaner)
  gem 'database_cleaner', require: false

  # Making tests easy on the fingers and eyes
  # (https://github.com/thoughtbot/shoulda)
  gem 'shoulda', require: false

  # Mocking and stubbing library (http://gofreerange.com/mocha/docs)
  gem 'mocha', require: false

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'

  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  # RSpec::CollectionMatchers lets you express expected outcomes on
  # collections of an object in an example.
  gem 'rspec-collection_matchers'

  # A set of RSpec matchers for testing Pundit authorisation policies.
  gem 'pundit-matchers'

  # This gem brings back assigns to your controller tests as well as assert_template
  # to both controller and integration tests.
  gem 'rails-controller-testing'

  # automating code review
  gem 'danger'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen'
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'

  # Simple Progress Bar for output to a terminal
  # (http://github.com/paul/progress_bar)
  gem 'progress_bar', require: false

  # Better error page for Rails and other Rack apps
  # (https://github.com/charliesome/better_errors)

  # TODO: Unlock this version once the Rails load error is fixed:
  #       https://github.com/BetterErrors/better_errors/issues/523
  gem 'better_errors', '2.9.1'

  # Retrieve the binding of a method's caller. Can also retrieve bindings
  # even further up the stack. (http://github.com/banister/binding_of_caller)
  gem 'binding_of_caller'

  # rspec command for spring
  # (https://github.com/jonleighton/spring-commands-rspec)
  gem 'spring-commands-rspec'

  # Profiles loading speed for rack applications. (http://miniprofiler.com)
  gem 'rack-mini-profiler'

  # Annotates Rails Models, routes, fixtures, and others based on the
  # database schema. (http://github.com/ctran/annotate_models)
  gem 'annotate'

  # Add comments to your Gemfile with each dependency's description.
  # (https://github.com/ivantsepp/annotate_gem)
  gem 'annotate_gem'

  # help to kill N+1 queries and unused eager loading.
  # (https://github.com/flyerhzm/bullet)
  gem 'bullet'

  # Documentation tool for consistent and usable documentation in Ruby.
  # (http://yardoc.org)
  gem 'yard'

  # TomDoc for YARD (http://rubyworks.github.com/yard-tomdoc)
  gem 'yard-tomdoc'
end
