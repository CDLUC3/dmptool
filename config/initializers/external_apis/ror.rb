# frozen_string_literal: true

# These configuration settings are used to communicate with the
# Research Organization Registry (ROR) API. For more information about
# the API and to verify that your configuration settings are correct,
# please refer to: https://github.com/ror-community/ror-api
Rails.configuration.x.dmproadmap.ror_download_url = 'https://zenodo.org/api/communities/ror-data/records?q=&sort=newest'
Rails.configuration.x.dmproadmap.ror_landing_page_url = 'https://ror.org/'
Rails.configuration.x.dmproadmap.ror_api_base_url = 'https://api.ror.org/'
Rails.configuration.x.dmproadmap.ror_heartbeat_path = 'heartbeat'
Rails.configuration.x.dmproadmap.ror_search_path = 'organizations'
Rails.configuration.x.dmproadmap.ror_max_pages = 2
Rails.configuration.x.dmproadmap.ror_max_results_per_page = 20
Rails.configuration.x.dmproadmap.ror_max_redirects = 3

Rails.configuration.x.dmproadmap.ror_full_catalog_file = Rails.root.join('tmp', 'ror', 'ror.json')
Rails.configuration.x.dmproadmap.ror_file_dir = Rails.root.join('tmp', 'ror')
Rails.configuration.x.dmproadmap.ror_checksum_file = Rails.root.join('tmp', 'ror', 'checksum.txt')
Rails.configuration.x.dmproadmap.ror_zip_file = Rails.root.join('tmp', 'ror', 'latest-ror-data.zip')
