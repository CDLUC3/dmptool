# frozen_string_literal: true

# Helper methods for Languages
module LanguagesHelper
  def languages
    return Language.sorted_by_abbreviation if Rails.env.development?

    Rails.cache.fetch('languages', expires_in: 1.hour) { Language.sorted_by_abbreviation.to_a }
  end
end
