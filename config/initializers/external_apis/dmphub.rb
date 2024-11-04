# frozen_string_literal: true

# The following 2 values are used to tie the service to its IdentifierScheme.
# make sure the :name if lowercase
Rails.configuration.x.dmproadmap.dmphub.name = 'dmphub'
Rails.configuration.x.dmproadmap.dmphub.description = 'A DMPHub based DOI minting service: https://github.com/CDLUC3/dmphub'

# Credentials for minting DOIs via a DMPHub system: https://github.com/CDLUC3/dmphub
# To disable this feature, simply set 'active' to false
Rails.configuration.x.dmproadmap.dmphub.token_path = 'oauth2/token'
Rails.configuration.x.dmproadmap.dmphub.fetch_path = 'dmps/%{dmp_id}'
Rails.configuration.x.dmproadmap.dmphub.mint_path = 'dmps'
Rails.configuration.x.dmproadmap.dmphub.update_path = 'dmps/%{dmp_id}'
Rails.configuration.x.dmproadmap.dmphub.delete_path = 'dmps/%{dmp_id}'
Rails.configuration.x.dmproadmap.dmphub.narrative_path = 'narratives?dmp_id=%{dmp_id}'
Rails.configuration.x.dmproadmap.dmphub.citation_path = 'citations'

Rails.configuration.x.dmproadmap.dmphub.callback_path = 'dmps/%{dmp_id}'
Rails.configuration.x.dmproadmap.dmphub.callback_method = 'patch'
