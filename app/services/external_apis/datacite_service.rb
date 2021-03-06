# frozen_string_literal: true

module ExternalApis

  # This service provides an interface to Datacite API.
  class DataciteService < BaseDoiService

    class << self

      def name
        Rails.configuration.x.datacite&.name
      end

      def description
        Rails.configuration.x.datacite&.description
      end

      # Retrieve the config settings from the initializer
      def landing_page_url
        Rails.configuration.x.datacite&.landing_page_url || super
      end

      def api_base_url
        Rails.configuration.x.datacite&.api_base_url || super
      end

      def max_pages
        Rails.configuration.x.datacite&.max_pages || super
      end

      def max_results_per_page
        Rails.configuration.x.datacite&.max_results_per_page || super
      end

      def max_redirects
        Rails.configuration.x.datacite&.max_redirects || super
      end

      def active?
        Rails.configuration.x.datacite&.active || super
      end

      def client_id
        Rails.configuration.x.datacite&.repository_id
      end

      def client_secret
        Rails.configuration.x.datacite&.password
      end

      def mint_path
        Rails.configuration.x.datacite&.mint_path
      end

      def shoulder
        Rails.configuration.x.datacite&.shoulder
      end

      # The callback_path is the API endpoint to send updates to once the Plan has changed
      # or been versioned
      def callback_path
        Rails.configuration.x.datacite&.callback_path
      end

      # Create a new DOI
      def mint_doi(plan:)
        return nil unless active?

        data = json_from_template(dmp: plan)
        resp = http_post(uri: "#{api_base_url}#{mint_path}",
                         additional_headers: {
                           "Content-Type": "application/vnd.api+json"
                         },
                         data: data, basic_auth: auth, debug: false)
        unless resp.present? && [200, 201].include?(resp.code)
          handle_http_failure(method: "Datacite mint_doi", http_response: resp)
          return nil
        end

        json = process_response(response: resp)
        return nil unless json.present?

        doi = json.fetch("data", "attributes": { "doi": nil })
                  .fetch("attributes", { "doi": nil })["doi"]

        add_subscription(plan: plan, doi: doi) if doi.present?
        doi
      end

       # Register the ApiClient behind the minter service as a Subscriber to the Plan
      # if the service has a callback URL and ApiClient
      def add_subscription(plan:, doi:)
        Rails.logger.warn "DataciteService - No ApiClient available for 'datacite'!" unless api_client.present?
        return plan unless plan.present? && doi.present? &&
                           callback_path.present? && api_client.present?

        Subscription.create(
          plan: plan,
          subscriber: api_client,
          callback_uri: callback_path % { dmp_id: doi.gsub(/https?:\/\/doi.org\//, "") },
          updates: true,
          deletions: true
        )
      end

      # Update the DOI
      def update_doi(plan:)
        return nil unless active? && plan.present?

        # Implement this later once we figure out versioning
        plan.present?
      end

      # Delete the DOI
      def delete_doi(plan:)
        return nil unless active? && plan.present?

        # implement this later if necessary and if reasonable. Is deleting a DOI feasible?
        plan.present?
      end

      private

      def auth
        { username: client_id, password: client_secret }
      end

      def json_from_template(dmp:)
        ActionController::Base.new.render_to_string(
          template: "/datacite/_minter",
          locals: { prefix: shoulder, data_management_plan: dmp }
        )
      end

      # rubocop:disable Metrics/MethodLength
      def process_response(response:)
        json = JSON.parse(response.body)
        unless json["data"].present? &&
               json["data"]["attributes"].present? &&
               json["data"]["attributes"]["doi"].present?
          log_error(method: "Datacite mint_doi",
                    error: StandardError.new("Unexpected JSON format from Datacite!"))
          return nil
        end
        json
      # If a JSON parse error occurs then return results of a local table search
      rescue JSON::ParserError => e
        log_error(method: "Datacite mint_doi", error: e)
        nil
      end
      # rubocop:enable Metrics/MethodLength

    end

  end

end
