# frozen_string_literal: true

require 'rails_helper'

describe 'users/mailer/reset_password_instructions' do
  before(:each) do
    controller.prepend_view_path 'app/views/branded'
    Rails.configuration.x.organisation.helpdesk_email = Faker::Internet.unique.email
    Rails.configuration.x.organisation.contact_us_url = nil
  end

  it 'renders correctly' do
    user = create(:user)
    token = SecureRandom.uuid

    assign :resource,  user
    assign :token, token

    render
    expect(rendered.include?("Hello #{user.email}")).to eql(true)
    expect(rendered.include?('Someone has requested a link to change')).to eql(true)
    expect(rendered.include?('Change my password')).to eql(true)
    expect(rendered.include?(token)).to eql(true)
    expect(rendered.include?('All the best')).to eql(true)
    expect(rendered.include?('Please do not reply to this email.')).to eql(true)
  end
end