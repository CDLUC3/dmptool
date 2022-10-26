# frozen_string_literal: true

module Users
  # Overrides to Devise's sign in/out sessions
  class SessionsController < Devise::SessionsController
    include Dmptool::Authenticatable

    # See the Authenticatable concern for additional callbacks

    before_action :configure_sign_in_params, only: [:create]

    # POST /resource/sign_in
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def create
      @bypass_sso = params[:sso_bypass] == 'true'

Rails.logger.warn "SSO BYPASS? #{@bypass_sso}"

      if sign_in_params[:email].blank?
        # If the email was left blank display an error
        redirect_to root_path, alert: _('Invalid email address!')

      elsif sign_in_params[:org_id].present? && !@bypass_sso
        # If there is an Org in the params then this is step 2 of the email+password workflow
        # so just let Devise sign them in normally
        super

      else
        # If there is no Org then the user provided their email in step 1 so we need
        # to send them to the Sign in OR Sign up page
        clean_up_passwords(resource)

        # If this is a user with an invitation, then clean up the stub data
        active_invite = resource.active_invitation?

        if active_invite
          resource.firstname = nil
          resource.surname = nil
          resource.org = org_from_email_domain(email_domain: resource.email&.split('@')&.last)
        end

        is_new_user = resource.new_record? || active_invite

        # If this is the first time someone has tried to create an account for an Org, save it
        resource.org.save if is_new_user && resource.org.present? && resource.org.new_record?


Rails.logger.warn "OAUTH2 WORKFLOW: #{session['oauth-referer']}"

        # If this is part of an API V2 Oauth workflow
        if session['oauth-referer'].present?
          oauth_hash = ApplicationService.decrypt(payload: session['oauth-referer'])

Rails.logger.warn "DECRYPTED: #{oauth_hash.inspect}"

          @client = ApiClient.where(uid: oauth_hash['client_id'])

          render 'doorkeeper/authorizations/new', layout: 'doorkeeper/application'
        else
          render is_new_user ? 'users/registrations/new' : :new
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: authentication_params(type: :sign_in))
    end

    # The path used after sign in.
    # rubocop:disable Metrics/AbcSize
    def after_sign_in_path_for(resource)
      # Determine if this was parft of an OAuth workflow for API V2
      if session['oauth-referer'].present?
        auth_hash = ApplicationService.decrypt(payload: session['oauth-referer']) || {}
        oauth_path = auth_hash['path']

        # Destroy the OAuth session info since we no longer need it
        session.delete('oauth-referer')
      elsif resource.language_id.present?
        session[:locale] = resource.language.abbreviation
      end
      # Change the locale if the user has a prefered language

      (oauth_path.presence || plans_path)
    end
    # rubocop:enable Metrics/AbcSize
  end
end
