# frozen_string_literal: true

# Helper methods for Global notifications and Flash messages
module NotificationsHelper
  # FA html class depending on Notification level
  #
  # Returns String
  def fa_classes(notification)
    case notification.level
    when 'warning'
      'fa-exclamation-circle'
    when 'danger'
      'fa-times-circle'
    else
      'fa-info-circle'
    end
  end
end
