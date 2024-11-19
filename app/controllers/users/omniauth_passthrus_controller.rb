# frozen_string_literal: true

module Users
  # Handlers for Omniauth Passthru methods
  class OmniauthPassthrusController < ApplicationController
    # POST /users/auth/shibboleth
    # rubocop:disable Metrics/AbcSize
    def shibboleth_passthru
      skip_authorization

      org = ::Org.find_by(id: shibboleth_passthru_params[:org_id])
      if org.present?
        entity_id = org.identifier_for_scheme(scheme: 'shibboleth')
        if entity_id.present?
          shib_login = Rails.configuration.x.dmproadmap.shibboleth_login_url
          target = user_shibboleth_omniauth_callback_url.gsub('http:', 'https:')

          # If this is part of an API V2 Oauth workflow, we need to pass the pre_auth
          # vals into the callback so they're available and useable by Doorkeeper
          if session['oauth-referer'].present?
            oauth_hash = ApplicationService.decrypt(payload: session['oauth-referer'])
            oauth_path_parts = oauth_hash['path'].split('?').last&.split('&')

            pre_auth = oauth_path_parts.map do |entry|
              parts = entry.split('=')
              if parts.length > 1
                val = parts.last.include?('%3A') ? CGI.unescape(parts.last) : parts.last
                "#{parts.first}=#{val}"
              else
                "#{parts.first}="
              end
            end

            target = "#{target}?#{CGI.escape(pre_auth.join('&'))}"
          end

          # initiate shibboleth login sequence
          redirect_to "#{shib_login}?target=#{target}&entityID=#{entity_id.value}"
        else
          redirect_to root_path, alert: _('Unable to connect to your institution\'s server!')
        end
      else
        redirect_to root_path, alert: _('Unable to connect to your institution\'s server!')
      end
    end
    # rubocop:enable Metrics/AbcSize

    private

    def shibboleth_passthru_params
      params.require(:user).permit(:org_id)
    end
  end
end
