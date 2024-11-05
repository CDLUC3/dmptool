# frozen_string_literal: true

# These configuration settings are meant to work with your DOI minting
# authority. If you opt to mint DOIs for your DMPs then you can add
# your configuration options here and then add extend the
# `app/services/external_apis/doi.rb` to communicate with their API.
#
# To disable thiis feature, simply set 'active' to false
Rails.configuration.x.dmproadmap.doi_landing_page_url = 'https://my.doi.org/'
Rails.configuration.x.dmproadmap.doi_api_base_url = 'https://my.doi.org/api/'
Rails.configuration.x.dmproadmap.doi_auth_path = 'auth_path'
Rails.configuration.x.dmproadmap.doi_heartbeat_path = 'heartbeat'
Rails.configuration.x.dmproadmap.doi_mint_path = 'doi'
Rails.configuration.x.dmproadmap.doi_active = false
