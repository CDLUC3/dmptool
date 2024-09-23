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
      if sign_in_params[:email].blank?
        # If the email was left blank display an error
        flash[:alert] = _('Invalid email address!')
        # redirect_to root_path, alert: _('Invalid email address!')

      elsif sign_in_params[:org_id].present? && !@bypass_sso
        # If this is part of an API V2 Oauth workflow, sign the user in and render the
        # authorization page. If the authentication fails rerender the page with an error
        if session['oauth-referer'].present?
          new_resource = warden.authenticate!(auth_options)
          oauth_hash = ApplicationService.decrypt(payload: session['oauth-referer'])

          @client = ApiClient.find_by(uid: oauth_hash['client_id'])
          @current_resource_owner = resource

          @pre_auth ||= Doorkeeper::OAuth::PreAuthorization.new(
            Doorkeeper.configuration,
            pre_auth_params,
            resource,
          )
          @pre_auth.send(:validate_client)

          render 'doorkeeper/authorizations/new', layout: 'doorkeeper/application'
        else
          # If there is an Org in the params then this is step 2 of the email+password workflow
          # so just let Devise sign them in normally
          super
        end

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

        # If this is part of an API V2 Oauth workflow
        if session['oauth-referer'].present?
          oauth_hash = ApplicationService.decrypt(payload: session['oauth-referer'])

          @client = ApiClient.find_by(uid: oauth_hash['client_id'])
          @current_resource_owner = resource

          @dmptool_oauth = generate_pre_auth(oauth_hash)

          @pre_auth ||= Doorkeeper::OAuth::PreAuthorization.new(
            Doorkeeper.configuration,
            pre_auth_params,
            resource,
          )
          @pre_auth.send(:validate_client)

          render 'doorkeeper/authorizations/new', layout: 'doorkeeper/application'
        else
          render 'static_pages/auth'
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    # DELETE /resource/sign_out
    def destroy
      # Delete the API token (used for React pages) a new token is generated each time the user logs in
      current_user.remove_ui_token!

      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message! :notice, :signed_out if signed_out
      yield if block_given?
      respond_to_on_destroy
    end

    protected

    def pre_auth_params
      params.permit(:client_id, :code_challenge, :code_challenge_method, :response_type,
                    :response_mode, :redirect_uri, :scope, :state)
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: authentication_params(type: :sign_in))
    end

    # The path used after sign in.
    # rubocop:disable Metrics/AbcSize
    def after_sign_in_path_for(resource)
      # Determine if this was part of an OAuth workflow for API V2
      if session['oauth-referer'].present? &&
        auth_hash = ApplicationService.decrypt(payload: session['oauth-referer']) || {}
        oauth_path = auth_hash['path']

        # Destroy the OAuth session info since we no longer need it
        session.delete('oauth-referer')
      elsif resource.language_id.present?
        session[:locale] = resource.language.abbreviation
      end
      # Refresh the User API token (used by React pages)
      resource.generate_ui_token! if resource.present?

      # Direct the user to the appropriate dashboard based on their permission level
      # TODO: Allow the dashboard to be the target once we're further along with development of the React pages
      landing_page_path = plans_path
      # landing_page_path = resource.can_org_admin? ? dashboard_path : plans_path

      # If we're in OAuth2 workkflow, stick with that, otherwise go to the dashboard
      (oauth_path.presence || landing_page_path)
    end
    # rubocop:enable Metrics/AbcSize

    def generate_pre_auth(oauth_hash)
      pre_auth = {}
      return {} unless oauth_hash.present?

      oauth_path_parts = oauth_hash['path'].split('?').last&.split('&')

      oauth_path_parts.each do |entry|
        parts = entry.split('=')
        pre_auth[parts.first] = parts.last
      end

      JSON.parse(pre_auth.to_json)
    end
  end
end
