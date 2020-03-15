# -------------------------------------------------------------
# start DMPTool customization
# -------------------------------------------------------------

module DmptoolHelper

  def access_sign_in_options_modal
    click_on "Sign in"
  end

  def access_sign_in_modal
    access_sign_in_options_modal
    click_on "Email address"
  end

  def access_create_account_modal
    access_sign_in_options_modal
    click_on "Create account with email address"
  end

  def access_shib_ds_modal
    access_sign_in_options_modal
    click_on "Your institution"
  end

  def generate_shibbolized_orgs(count)
    (1..count).each do |idx|
      create(:org, :organisation, :shibbolized, is_other: false)
    end
  end

  def select_shib_ds_org(org)
    find("#org_org_name").set(org.name)
    sleep(0.2)

    # Click the Org from the dropdown autocomplete
    first("#ui-id-#{org.id}").click
  end

  def mock_omniauth_call(scheme, user)

    case scheme
    when "shibboleth"
      # Mock the OmniAuth payload for Shibboleth
      {
        provider: scheme,
        uid: "123ABC",
        info: {
          email: user.email,
          givenname: user.firstname,
          sn: user.surname,
          identity_provider: user.org.identifier_for_scheme(scheme: "shibboleth")&.value
        }
      }

    when "orcid"
      # Moch the Omniauth payload for Orcid
      {
        provider: scheme,
        uid: "ORCID123"
      }
    else
      {
        provider: scheme,
        uid: "testing"
      }
    end
  end

end

# -------------------------------------------------------------
# end DMPTool customization
# -------------------------------------------------------------
