# frozen_string_literal: true

json.partial! 'api/v3/standard_response'

@total_items = @wips.length
json.items @wips do |wip|
  json.dmp JSON.parse(wip.to_json).fetch('dmp', {})
end
