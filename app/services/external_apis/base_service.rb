# frozen_string_literal: true

require "httparty"

module ExternalApis

  class ExternalApiError < StandardError; end

  class BaseService

    class << self

      # The following should be defined in each inheriting service's initializer.
      # For example:
      #   ExternalApis::RorService.setup do |config|
      #     config.x.ror.landing_page_url = "https://example.org/"
      #     config.x.ror.api_base_url = "https://api.example.org/"
      #   end
      def landing_page_url
        nil
      end

      def api_base_url
        nil
      end

      def max_pages
        5
      end

      def max_results_per_page
        50
      end

      def max_redirects
        3
      end

      def active?
        false
      end

      # The standard headers to be used when communicating with an external API.
      # These headers can be overriden or added to when calling an external API
      # by sending your changes in the `additional_headers` attribute of
      # `http_get`
      def headers
        hash = {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "User-Agent": "#{app_name} (#{app_email})"
        }
        hash.merge({ "Host": URI(api_base_url).hostname.to_s })
      rescue URI::InvalidURIError => e
        handle_uri_failure(method: "BaseService.headers #{e.message}",
                           uri: api_base_url)
        hash
      end

      # Logs the results of a failed HTTP response
      def handle_http_failure(method:, http_response:)
        content = http_response.inspect
        msg = "received a #{http_response&.code} response with: #{content}!"
        log_error(method: method, error: ExternalApiError.new(msg))
      end

      # Logs the results of a failed HTTP response
      def handle_uri_failure(method:, uri:)
        msg = "received an invalid uri: '#{uri&.to_s}'!"
        log_error(method: method, error: ExternalApiError.new(msg))
      end

      # Logs the specified error along with the full backtrace
      def log_error(method:, error:)
        return unless method.present? && error.present?

        Rails.logger.error "#{self.class.name}.#{method} #{error.message}"
        Rails.logger.error error.backtrace
      end

      # Emails the error and response to the administrators
      def notify_administrators(obj:, response: nil, error: nil)
        return false unless obj.present? && response.present?

        message = "#{obj.class.name} - #{obj.respond_to?(:id) ? obj.id : ""}"
        message += "<br>----------------------------------------<br><br>"

        message += "Sent: #{pp(json_from_template(plan: obj))}" if obj.is_a?(Plan)
        message += "<br>----------------------------------------<br><br>" if obj.is_a?(Plan)

        message += "#{self.name} received the following unexpected response:<br>"
        message += "#{pp(response.inspect)}"
        message += "<br>----------------------------------------<br><br>"
        message += error.message if error.present? && error.is_a?(StandardError)
        message += error.backtrace if error.present? && error.is_a?(StandardError)

        UserMailer.notify_administrators(message).deliver_now
      end

      private

      # Retrieves the application name from dmproadmap.rb initializer or uses the App name
      def app_name
        ApplicationService.application_name
      end

      # Retrieves the helpdesk email from dmproadmap.rb initializer or uses the contact page url
      def app_email
        dflt = Rails.application.routes.url_helpers.contact_us_url || ""
        Rails.configuration.x.organisation.fetch(:helpdesk_email, dflt)
      end

      # Makes a GET request to the specified uri with the additional headers.
      # Additional headers are combined with the base headers defined above.
      def http_get(uri:, additional_headers: {}, debug: false)
        return nil unless uri.present?

        HTTParty.get(uri, options(additional_headers: additional_headers,
                                  debug: debug))
      rescue URI::InvalidURIError => e
        handle_uri_failure(method: "BaseService.http_get #{e.message}",
                           uri: uri)
        nil
      rescue HTTParty::Error => e
        handle_http_failure(method: "BaseService.http_get #{e.message}",
                            http_response: resp)
        resp
      end

      # Makes a POST request to the specified uri with the additional headers.
      # Additional headers are combined with the base headers defined above.
      # rubocop:disable Metrics/MethodLength
      def http_post(uri:, additional_headers: {}, data: {}, basic_auth: nil, debug: false)
        return nil unless uri.present?

        opts = options(additional_headers: additional_headers, debug: debug)
        opts[:body] = data
        opts[:basic_auth] = basic_auth if basic_auth.present?
        HTTParty.post(uri, opts)
      rescue URI::InvalidURIError => e
        handle_uri_failure(method: "BaseService.http_post #{e.message}",
                           uri: uri)
        nil
      rescue HTTParty::Error => e
        handle_http_failure(method: "BaseService.http_post #{e.message}",
                            http_response: resp)
        resp
      end
      # rubocop:enable Metrics/MethodLength

      # Makes a PUT request to the specified uri with the additional headers.
      # Additional headers are combined with the base headers defined above.
      # rubocop:disable Metrics/MethodLength
      def http_put(uri:, additional_headers: {}, data: {}, basic_auth: nil, debug: false)
        return nil unless uri.present?

        opts = options(additional_headers: additional_headers, debug: debug)
        opts[:body] = data
        opts[:basic_auth] = basic_auth if basic_auth.present?
        HTTParty.put(uri, opts)
      rescue URI::InvalidURIError => e
        handle_uri_failure(method: "BaseService.http_put #{e.message}",
                           uri: uri)
        nil
      rescue HTTParty::Error => e
        handle_http_failure(method: "BaseService.http_put #{e.message}",
                            http_response: resp)
        resp
      end
      # rubocop:enable Metrics/MethodLength

      # Options for the HTTParty call
      def options(additional_headers: {}, debug: false)
        hash = {
          headers: headers.merge(additional_headers),
          follow_redirects: true,
          limit: 6
        }
        hash[:debug_output] = $stdout if debug
        hash
      end

    end

  end

end
