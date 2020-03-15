require 'rails_helper'

RSpec.feature "Sessions", type: :feature do

  # -------------------------------------------------------------
  # start DMPTool customization
  # Initialize an org
  # -------------------------------------------------------------
  include DmptoolHelper
  # -------------------------------------------------------------
  # end DMPTool customization
  # -------------------------------------------------------------

  let(:user) { create(:user) }

  scenario "User signs in successfully with email and password", :js do
    # -------------------------------------------------------------
    # start DMPTool customization
    # -------------------------------------------------------------
    create(:org, managed: true)

    # Setup
    visit root_path

    access_sign_in_modal
    # -------------------------------------------------------------
    # end DMPTool customization
    # -------------------------------------------------------------

    # Action
    fill_in :signin_user_email, with: user.email
    fill_in :signin_user_password, with: user.password
    click_button "Sign in"

    # Expectation
    expect(current_path).to eql(plans_path)
    expect(page).to have_text(user.firstname)
    expect(page).to have_text(user.surname)
  end

  scenario "User fails sign in with email and password", :js do
    # -------------------------------------------------------------
    # start DMPTool customization
    # -------------------------------------------------------------
    create(:org, managed: true)

    # Setup
    visit root_path

    access_sign_in_modal
    # -------------------------------------------------------------
    # end DMPTool customization
    # -------------------------------------------------------------

    # Action
    fill_in :signin_user_email, with: user.email
    fill_in :signin_user_password, with: "rong-password"
    click_button "Sign in"

    # Expectation
    expect(current_path).to eql(root_path)
    expect(page).not_to have_text(user.firstname)
    expect(page).not_to have_text(user.surname)
    expect(page).to have_text("Error")
  end

  # -------------------------------------------------------------
  # start DMPTool customization
  # Shibboleth sign in
  # -------------------------------------------------------------
=begin
  scenario "User is redirected to Shibboleth Login for a shibbolized org", :js do
    generate_shibbolized_orgs(12)
    org = Org.participating.first

    # Setup
    visit root_path
    access_shib_ds_modal

    select_shib_ds_org(org)

    #click_button "Go"
    click_link "See the full list of participating institutions"
    first("a[href^=\"/orgs/shibboleth/\"]").click

    expect(current_path).to eql("/Shibboleth.sso/Login")
  end

  scenario "User is shown the Org's custom sign in page for non-shibbolized Orgs", :js do
    org = create(:org, managed: true)
    generate_shibbolized_orgs(10)

    # Setup
    visit root_path
    access_shib_ds_modal
    select_shib_ds_org(org)
    #click_button "Go"
    click_link "See the full list of participating institutions"
    first("a[href^=\"/org_logos/\"]").click

    expect(find(".branding-name").present?).to eql(true)
  end
=end
  # -------------------------------------------------------------
  # end DMPTool customization
  # -------------------------------------------------------------

end
