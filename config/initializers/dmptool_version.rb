# frozen_string_literal: true

# The capistrano deploy writes out a `.version` file into the root dir
# If it exists, add it to the configuration so that it will be available
# on the `views/branded/layout/_footer.html.erb`
Rails.configuration.x.dmproadmap.dmptool.version = File.read('.version') if File.exist?('.version')
