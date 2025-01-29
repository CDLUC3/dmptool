Rails.application.configure do
  config.lograge.enabled = true

  # Use the LogStash format
  config.lograge.formatter = Lograge::Formatters::Logstash.new

  # Include controller info in the available log payload
  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      user_id: controller.current_user.try(:id),
      params: controller.params
    }
  end

  # Include the custom info from the event and payload
  config.lograge.custom_options = lambda do |event|
    param_exceptions = %w(controller action format id)

    {
      # Timestamp
      time: event.time,
      # Controller params
      params: event.payload[:params].except(*param_exceptions),
      # The current user
      user: event.payload[:user_id],
      # Caller
      host: event.payload[:host]
    }
  end

  # Continue creating the basic Rails logs
  config.lograge.keep_original_rails_log = true

  # Define the location of the Lograge format
  config.lograge.logger = ActiveSupport::Logger.new "#{Rails.root}/log/lograge_#{Rails.env}.log"
end