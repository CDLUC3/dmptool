# frozen_string_literal: true

# Credentials for minting DOIs via re3data
# To disable this feature, simply set 'active' to false
Rails.configuration.x.dmproadmap.re3data_landing_page_url = 'https://www.re3data.org/'
Rails.configuration.x.dmproadmap.re3data_api_base_url = 'https://www.re3data.org/api/v1/'
Rails.configuration.x.dmproadmap.re3data_list_path = 'repositories'
Rails.configuration.x.dmproadmap.re3data_repository_path = 'repository/'
