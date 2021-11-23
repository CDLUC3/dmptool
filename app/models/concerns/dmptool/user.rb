# frozen_string_literal: true

module Dmptool
  # DMPTool specific extensions to the User model
  # rubocop:disable Metrics/BlockLength
  module User
    extend ActiveSupport::Concern

    class_methods do
      # ===============
      # = Invitations =
      # ===============

      # Devise Invitable was cumbersome and did not work well with our workflow
      # so we removed that gem but still use the invitation_token field to allow us
      # to create the stub User record and attach it to the Plan.
      #
      # We still want to allow users to be invited though and need to create a stub
      # User record that can be associated with the Plan (via a Role). When the
      # invitation is accepted, the user will have an opportunity to overwrite
      # the stub :firstname, :surname and :org

      # Create the stub User and sent them the invitation email
      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def invite!(inviter:, plan:, params:)
        return nil unless inviter.present? && plan.present? &&
                          params.present? && params[:email].present?

        params[:firstname] = 'First' unless params[:firstname].present?
        params[:surname] = 'Last' unless params[:surname].present?
        params[:password] = SecureRandom.uuid unless params[:password].present?
        params[:invitation_token] = SecureRandom.uuid
        params[:invitation_created_at] = Time.now
        params[:invited_by_id] = inviter.id
        params[:invited_by_type] = inviter.class.name
        params[:org_id] = inviter.org_id
        params[:invitation_plan_id] = plan&.id

        ::User.transaction do
          invitee = ::User.new(params)
          if invitee.save(params)
            UserMailer.invitation(inviter, invitee, plan).deliver_now
            invitee.update(invitation_sent_at: Time.now)
            invitee
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      # ============
      # = Omniauth =
      # ============

      # Load the user based on the scheme and id provided by the Omniauth call
      # rubocop:disable Metrics/AbcSize
      def from_omniauth(scheme_name:, omniauth_hash:)
        return nil unless scheme_name.present? && omniauth_hash[:uid].present?

        # Find the User by the :uid returned by omniauth
        user = Identifier.by_scheme_name(scheme_name, 'User')
                         .where(value: omniauth_hash[:uid])
                         .first&.identifiable
        return user if user.present?

        omniauth_info = omniauth_hash.fetch(:info, {})
        names = extract_omniauth_names(hash: omniauth_info)

        user = User.new(
          email: extract_omniauth_email(hash: omniauth_info),
          firstname: names.fetch(:firstname, ''),
          surname: names.fetch(:surname, ''),
          org: extract_omniauth_org(scheme: scheme_name, hash: omniauth_info)
        )

        # Get the Oauth access token if available
        token = ExternalApiAccessToken.from_omniauth(user: user, service: scheme_name, hash: @omniauth)
        user.external_api_access_tokens = [token] if token.present?
        user
      end
      # rubocop:enable Metrics/AbcSize

      # Extract the 1st email
      def extract_omniauth_email(hash:)
        hash.present? ? hash.fetch(:email, '').split(';')[0] : nil
      end

      # Find the User names from the omniauth info
      # rubocop:disable Metrics/AbcSize
      def extract_omniauth_names(hash:)
        return {} unless hash.present?

        out = {
          firstname: hash.fetch(:givenname, hash.fetch(:firstname, '')),
          surname: hash.fetch(:sn, hash.fetch(:surname, hash.fetch(:lastname, '')))
        }
        return out if out[:firstname].present? || out[:surname].present?

        names = hash[:name].split
        {
          firstname: names[0],
          surname: names.length > 1 ? names[names.length - 1] : nil
        }
      end
      # rubocop:enable Metrics/AbcSize
    end

    included do
      # ===============
      # = Invitations =
      # ===============

      # Devise Invitable was cumbersome and did not work well with our workflow
      # so we removed that gem but still use the invitation_token field to allow us
      # to create the stub User record and attach it to the Plan.
      #
      # We still want to allow users to be invited though and need to create a stub
      # User record that can be associated with the Plan (via a Role). When the
      # invitation is accepted, the user will have an opportunity to overwrite
      # the stub :firstname, :surname and :org

      # Whether or not  the user has an a ctive invitation
      def active_invitation?
        invitation_token.present? && invitation_accepted_at.nil?
      end

      # Updates the accept date.
      def accept_invitation
        return false unless active_invitation?

        update(invitation_accepted_at: Time.now)
      end

      # ==================
      # = API V2 HELPERS =
      # ==================

      # Fetch the access token for the specified service
      def access_token_for(external_service_name:)
        return nil unless external_service_name.present? && external_api_access_tokens.any?

        tokens = external_api_access_tokens.select do |token|
          token.external_service_name == external_service_name && token.active?
        end
        tokens.first
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end