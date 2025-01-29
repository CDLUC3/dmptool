Rails.application.configure do
  config.lograge.enabled = true

  # Use the LogStash format to get JSON instead of the standard Lograge one-liners
  config.lograge.formatter = Lograge::Formatters::Logstash.new

  # Include controller info in the available log payload
  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      user_id: controller.current_user.try(:id),
    }
  end

  # Include the custom info from the event and payload
  config.lograge.custom_options = lambda do |event|
    params_to_skip = %w[_method action authenticity_token commit controller format id]

    {
      params: event.payload[:params].except(*params_to_skip)
    }
  end

  # Continue creating the basic Rails logs
  config.lograge.keep_original_rails_log = true

  # Define the location of the Lograge format
  config.lograge.logger = ActiveSupport::Logger.new "#{Rails.root}/log/lograge_#{Rails.env}.log"
end