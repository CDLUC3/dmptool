# frozen_string_literal: true

# The following 2 values are used to tie the service to its IdentifierScheme.
# make sure the :name if lowercase
Rails.configuration.x.dmproadmap.orcid.name = 'orcid'

# Credentials for the ORCID member API are pulled in from the Devise omniauth config
# To disable this feature, simply set 'active' to false
Rails.configuration.x.dmproadmap.orcid.work_path = '%{id}/work/'
Rails.configuration.x.dmproadmap.orcid.callback_path = 'work/%{put_code}'
Rails.configuration.x.dmproadmap.orcid.active = true
