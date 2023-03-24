# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign up and bypass SSO' do
  include Helpers::DmptoolHelper
  include Helpers::AutocompleteHelper
  include Helpers::IdentifierHelper

  before do
    @original_shib = Rails.configuration.x.shibboleth&.enabled
    @original_disco = Rails.configuration.x.shibboleth.use_filtered_discovery_service
    Rails.configuration.x.shibboleth&.enabled = true
    Rails.configuration.x.shibboleth.use_filtered_discovery_service = true
    mock_blog
    @email_domain = 'foo.edu'
    @org = create(:org, name: 'Test Org', contact_email: "help-desk@#{@email_domain}")
    @registry_org = create(:registry_org, name: 'Test Registry Org', home_page: "http://#{@email_domain}", org: @org)
    @user = create(:user, email: "jane@#{@email_domain}", org: @org)
    visit root_path
  end

  after do
    Rails.configuration.x.shibboleth.enabled = @original_shib
    Rails.configuration.x.shibboleth.use_filtered_discovery_service = @original_disco
  end

  it 'does not display bypass link for unknown user with a known email domain for an unshibbolized org', js: true do
    email = "anna@#{@email_domain}"
    fill_in 'Email address', with: email
    click_on 'Continue'

    expect(page).to have_text('New Account Sign Up')
    expect(find_by_id('user_disabled_email').value).to eql(email)
    expect(find_by_id('org_autocomplete_name').value).to eql(@org.name)
    expect(page).not_to have_text('Sign up with non SSO')
  end

  it 'handles unknown user with a known email domain for an shibbolized org', js: true do
    create_shibboleth_entity_id(org: @org)
    email = "anna@#{@email_domain}"
    fill_in 'Email address', with: email
    click_on 'Continue'

    expect(page).to have_text('New Account Sign Up')
    expect(find_by_id('user_disabled_email').value).to eql(email)
    expect(page).to have_text(CGI.escapeHTML(@org.name))
    expect(page).to have_text('Sign up with Institution (SSO)')
    expect(page).to have_text('Sign up with non SSO')

    click_on 'Sign up with non SSO'

    expect(page).to have_text('New Account Sign Up')
    expect(find_by_id('user_disabled_email').value).to eql(email)
    expect(find_by_id('org_autocomplete_name').value).to eql(@org.name)

    within("form[action=\"#{user_registration_path}\"]") do
      fill_in 'First Name', with: Faker::Movies::StarWars.character.split.first
      fill_in 'Last Name', with: Faker::Movies::StarWars.character.split.last
      select_an_org('#sign-up-org', @org.name, 'Institution')
      fill_in 'Password', with: SecureRandom.uuid
      # Need to use JS to set the accept terms label since dmptool-ui treats the
      # whole thing as a label and their particular label has a URL so 'clicking' it
      # via Capybara results in going to the URL behind that link :/
      page.execute_script("document.getElementById('user_accept_terms').checked = true;")
      click_button 'Sign up'
    end

    expect(current_path).to eql(plans_path)
    expect(page).to have_text('Welcome')
    expect(page).to have_text('You are now ready to create your first DMP.')
  end
end
