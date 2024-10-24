# frozen_string_literal: true

# Helpers methods for handling I18n and GetText
class LocaleService
  class << self
    # Returns the default locale/language
    def default_locale
      abbrev = Language.default.try(:abbreviation) if Language.table_exists?
      (abbrev.presence || Rails.configuration.x.locales.default)
    end

    alias default_language default_locale

    # Returns the available locales/languages
    def available_locales
      locales = Language.sorted_by_abbreviation.pluck(:abbreviation).presence if Language.table_exists?
      (locales.presence || [default_locale])
    end

    alias available_languages available_locales

    # Converts the locale to the i18n format (e.g. `en-GB`)
    def to_i18n(locale:)
      join_char = Rails.configuration.x.locales.i18n_join_character
      locale = default_locale if locale.blank?
      convert(string: locale, join_char: join_char)
    end

    # Converts the locale to the i18n format (e.g. `en_GB`)
    def to_gettext(locale:)
      join_char = Rails.configuration.x.locales.gettext_join_character
      locale = default_locale if locale.blank?
      convert(string: locale, join_char: join_char)
    end

    private

    def convert(string:, join_char: Rails.configuration.x.locales.gettext_join_character)
      language, region = string.to_s.scan(/[a-zA-Z]{2}/)
      language.downcase! if language.present?
      region.upcase!     if region.present?
      region.present? ? "#{language}#{join_char}#{region}" : language
    end
  end
end
