# frozen_string_literal: true

module Dmptool

  module Controllers

    module OmniauthCallbacks

      protected

      def process_omniauth_callback(scheme)
        # There is occassionally a disconnect between the id of the Scheme
        # when the base controller's dynamic methods were defined and the
        # time this method is called, so reload the scheme
        scheme = IdentifierScheme.find_by(name: scheme.name)

        if request.env.present?
          omniauth = request.env["omniauth.auth"] || request.env
        else
          omniauth = {}
        end

        if scheme.name == "shibboleth"
          provider = _("your institutional credentials")
        else
          provider = scheme.description
        end

        # if the user is already signed in then we are attempting to attach
        # omniauth credentials to an existing account
        if current_user.present? && omniauth.fetch(:uid, "").present?
          if attach_omniauth_credentials(current_user, scheme, omniauth)
            # rubocop:disable LineLength
            flash[:notice] = _("Your account has been successfully linked to %{scheme}.") % {
              scheme: provider
            }
            # rubocop:enable LineLength
          else
            flash[:alert] = _("Unable to link your account to %{scheme}") % {
              scheme: provider
            }
          end
          redirect_to edit_user_registration_path

        else
          # Attempt to locate the user via the credentials returned by omniauth
          @user = User.from_omniauth(OpenStruct.new(omniauth))

          # If we found the user by their omniauth creds then sign them in
          if @user.present?
            flash[:notice] = _("Successfully signed in")
            sign_in_and_redirect @user, event: :authentication

          else
            # Otherwise attempt to locate the user via the email provided in
            # the omniauth creds
            new_user = omniauth_hash_to_new_user(scheme, omniauth)
            @user = User.where_case_insensitive("email", new_user.email).first

            # If we found the user by email
            if @user.present?
              # sign them in and attach their omniauth credentials to the account
              if attach_omniauth_credentials(@user, scheme, omniauth)
                flash[:notice] = _("Successfully signed in with %{scheme}.") % {
                  scheme: provider
                }
                sign_in_and_redirect @user, event: :authentication

              else
                # Unable to attach the omniauth creds to the user
                flash[:alert] = _("Unable to sign in with %{scheme}") % {
                  scheme: provider
                }
                session["devise.#{scheme.name.downcase}_data"] = omniauth
                redirect_to new_user_registration_path,
                          notice: _('It looks like this is your first time logging in. Please verify and complete the information below to finish creating an account.')
              end

            # If we could not find a match take them to the account setup page
            else
              session["devise.#{scheme.name.downcase}_data"] = omniauth
              #render template: 'views/devise/registrations/new'
              redirect_to new_user_registration_path,
                          notice: _('It looks like this is your first time logging in. Please verify and complete the information below to finish creating an account.')
            end
          end
        end
      end

      private

      def attach_omniauth_credentials(user, scheme, omniauth)
        # Attempt to find or attach the omniauth creds
        ui = Identifier.where(identifier_scheme: scheme, identifiable: user).first

        if ui.present?
          if ui.value != omniauth[:uid]
            ui.update(value: omniauth[:uid])
          end
          true
        else
          id = Identifier.create(identifier_scheme: scheme, identifiable: user,
                            value: omniauth[:uid])
          id
        end
      end

      def omniauth_hash_to_new_user(scheme, omniauth)
        omniauth_info = omniauth.fetch(:info, {})
        names = extract_omniauth_names(omniauth_info)
        User.new(
          email: extract_omniauth_email(omniauth_info),
          firstname: names.fetch(:firstname, ""),
          surname: names.fetch(:surname, ""),
          org: extract_omniauth_org(scheme, omniauth_info)
        )
      end

      def extract_omniauth_email(hash)
        hash.fetch(:email, "").split(";")[0]
      end

      def extract_omniauth_names(hash)
        firstname = hash.fetch(:givenname, hash.fetch(:firstname, ""))
        surname = hash.fetch(:sn, hash.fetch(:surname, hash.fetch(:lastname, "")))

        if hash[:name].present? && (!firstname.present? || !surname.present?)
          names = hash[:name].split(" ")
          firstname = names[0]
          if names.length > 1
            surname = names[names.length - 1]
          end
        end
        { firstname: firstname, surname: surname }
      end

      def extract_omniauth_org(scheme, hash)
        idp_name = hash.fetch(:identity_provider, "").downcase
        if idp_name.present?
          idp = Identifier.where(identifier_scheme: scheme)
                          .where("LOWER(value) = ?", idp_name).first
          if idp.present?
            org = idp.identifiable
          end
        end
        org.present? ? org : Org.where(is_other: true).first
      end

    end

  end

end
