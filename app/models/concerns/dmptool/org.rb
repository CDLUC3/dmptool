# frozen_string_literal: true

module Dmptool
  # DMPTool specific extensions to the Org model
  # rubocop:disable Metrics/BlockLength
  module Org
    extend ActiveSupport::Concern

    class_methods do
      def default_contact_name
        format(_('%{app_name} helpdesk'), app_name: ApplicationService.application_name)
      end

      def default_contact_email
        Rails.configuration.x.dmproadmap.organisation_helpdesk_email
      end

      def participating
        includes(identifiers: :identifier_scheme).where(managed: true)
      end

      # Returns all Org's with a Shibboleth entityID stored in the Identifiers table
      # This is used on the app/views/shared/_shib_sign_in_form.html.erb partial which
      # is only used if you have `shibboleth.use_filtered_discovery_service` enabled.
      def shibbolized
        org_ids = Identifier.by_scheme_name('shibboleth', 'Org').pluck(:identifiable_id)
        where(managed: true, id: org_ids)
      end

      # rubocop:disable Metrics/AbcSize
      def initialize_from_org_autocomplete(name:, funder: false)
        return nil if name.blank?

        is_institution = !funder && (name.downcase.include?('college') ||
                                     name.downcase.include?('university'))
        org = ::Org.new(
          name: name.split.map(&:capitalize).join(' '),
          contact_email: default_contact_email,
          contact_name: default_contact_name,
          is_other: false,
          managed: false,
          funder: funder,
          institution: is_institution && !funder,
          organisation: !is_institution && !funder
        )
        org.abbreviation = org.name_to_abbreviation
        org
      end
      # rubocop:enable Metrics/AbcSize

      # Hardcoded list of email domains that need special handling because the email domain
      # does not match the organization's domain
      def intercept_from_email_domain(email_domain)
        case email_domain.downcase
        when "childrens.harvard.edu"
          matches = ::RegistryOrg.where("home_page LIKE '%childrenshospital.org'")
          return nil if matches.empty? || matches.first.org_id.nil?

          ::Org.find_by(id: matches.first.org_id)
        when "txst.edu", "txstate.edu"
          matches = ::RegistryOrg.where("home_page LIKE '%txst.edu'")
          return nil if matches.empty? || matches.first.org_id.nil?

          ::Org.find_by(id: matches.first.org_id)
        else
          nil
        end
      end

      # Attempt to determine the Org (or RegistryOrg) based on the email's domain
      # rubocop:disable Metrics/AbcSize
      def from_email_domain(email_domain:)
        return nil if email_domain.blank?
        return nil if ignored_email_domains.include?(email_domain.downcase)

        # First see if the email domain requires special handling
        org = intercept_from_email_domain(email_domain)
        # If it did not, then try to find it by matching the email domain to RegistryOrg home_page
        org = ::RegistryOrg.from_email_domain(email_domain: email_domain) unless org.present?
        return org if org.present?

        # Nothing was found, so try to see what others with that email domain belong to
        hash = ::User.where('email LIKE ?', "%@#{email_domain.downcase}").group(:org_id).count
        return nil if hash.blank?

        # We could potentially have multiple Org matches here, so use the one with the most users
        selected = hash.select { |_k, v| v == hash.values.max }
        find_by(id: selected.keys.first)
      end
      # rubocop:enable Metrics/AbcSize

      # Class method shortcut to the name_to_abbreviation instance method
      def name_to_abbreviation(name:)
        return '' if name.blank?

        ::Org.new(name: name).name_to_abbreviation
      end

      # Create an Org from an existing RegistryOrg
      def from_registry_org!(registry_org:)
        return nil unless registry_org.is_a?(RegistryOrg)
        return registry_org.org if registry_org.org_id.present?

        org = registry_org.to_org
        org.save
        org
      end

      def default_create_plan_api_subject
        'A new data management plan (DMP) for the Non Partner Institution was started for you.'
      end

      # rubocop:disable Layout/LineLength
      def default_create_plan_api_body
        'A new data management plan (DMP) has been started for you by the %{external_system_name}. If you have any questions or need help, please contact the administrator for the Non Partner Institution at <a href="mailto:uc3@ucop.edu">uc3@ucop.edu</a>.'
      end
      # rubocop:enable Layout/LineLength
    end

    included do
      # Words to skip when building a default abbreviation from the Org name
      def abbreviation_stop_words
        %w[a and of the]
      end

      # Whether or not this Org is setup for SSO via Shibboleth
      def shibbolized?
        managed? && identifier_for_scheme(scheme: 'shibboleth').present?
      end

      # Returns the name of the Org excluding anything in parenthesis. For example:
      #    'Example University (EU)'  ->  'Example University'
      #    'Sample College (sample.edu)'  ->  'Sample College'
      def name_without_alias
        name&.split(' (')&.first&.strip
      end

      # Convert the Org's name into an abbreviation
      def name_to_abbreviation
        name_without_alias.split
                          .reject { |word| abbreviation_stop_words.include?(word.downcase) }
                          .map { |word| word[0].upcase }
                          .join
      end

      # If the org was created and has a fundref/ror id then it was derived from a
      # User's selection of a RegistryOrg in the UI. We need to update the
      # registry_orgs.org_id to establish the relationship.
      #
      # This is called by an after_create callback on the Org model!
      def connect_to_registry_org
        registry_org = RegistryOrg.find_by('LOWER(name) = ?', name.downcase)
        return true if registry_org.blank?

        # Attach the identifiers
        %w[fundref ror].each do |scheme_name|
          value = registry_org.send(:"#{scheme_name}_id")
          next if value.blank?

          id = registry_org.ror_or_fundref_to_identifier(scheme_name: scheme_name,
                                                         value: value)
          next if id.blank?

          id.identifiable = self
          id.save if id.new_record?
        end

        # Update the original RegistryOrg with the new org's association
        registry_org.update(org_id: id)
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
