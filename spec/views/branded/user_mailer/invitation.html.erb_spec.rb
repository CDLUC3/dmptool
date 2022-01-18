# frozen_string_literal: true

require 'rails_helper'

describe 'user_mailer/invitation' do
  include DmptoolHelper

  before(:each) do
    controller.prepend_view_path 'app/views/branded'

    @plan = create(:plan, org: create(:org), template: create(:template, org: create(:org)))
    assign :plan, @plan
    assign :org_name, @plan.template.org.name
    assign :org_email, @plan.template.org.contact_email

    @invitee = create(:user)
    assign :invitee, @invitee
  end

  it 'renders correctly when the inviter is a ApiClient (via API V2 plan creation)' do
    @plan.template.org.api_create_plan_email_body = "Foo %{external_system_name} bar"

    inviter = create(:api_client)
    assign :inviter_type, 'ApiClient'
    assign :inviter_name, inviter.name
    assign :client_name, inviter.description

    render
    expect(rendered.include?("Hello #{@invitee.name}")).to eql(true)
    expect(rendered.include?("Foo #{inviter.description} bar")).to eql(true)
    expect(rendered.include?('Please sign in or sign up at <a')).to eql(true)
    expect(rendered.include?("The #{@plan.template.org.name} DMPTool team")).to eql(true)
    expect(rendered.include?("href=\"mailto:#{@plan.template.org.contact_email}\"")).to eql(true)
  end
  it 'renders correctly when the inviter is a Org (via Email Template modal)' do
    @plan.template.email_body = "Foo %{dmp_title} bar %{org_name} baz %{org_admin_email}"

    inviter = create(:org)
    assign :inviter_type, 'Org'
    assign :inviter_name, inviter.name

    render
    expect(rendered.include?("Hello #{@invitee.name}")).to eql(true)
    expect(rendered.include?("Foo #{@plan.title} bar #{@plan.template.org.name} baz")).to eql(true)
    expect(rendered.include?(@plan.template.org.name)).to eql(true)
    expect(rendered.include?('Please sign in or sign up at <a')).to eql(true)
    expect(rendered.include?("The #{@plan.template.org.name} DMPTool team")).to eql(true)
    expect(rendered.include?("href=\"mailto:#{@plan.template.org.contact_email}\"")).to eql(true)
  end
  it 'renders correctly when the inviter is a User (via Contributors tab)' do
    inviter = create(:user)
    assign :inviter_type, 'User'
    assign :inviter_name, inviter.name(false)

    render
    expect(rendered.include?("Hello #{@invitee.name(false)}")).to eql(true)
    expect(rendered.include?("Your colleague #{inviter.name(false)} has invited you")).to eql(true)
    expect(rendered.include?(inviter.name(false)))
    expect(rendered.include?('Please sign in or sign up at <a')).to eql(true)
    expect(response).to render_template(partial: 'user_mailer/_email_signature')
  end
  it 'uses the invitee email instead of stub name if the user has an active invitation' do
    @invitee.invitation_token = SecureRandom.uuid
    @invitee.invitation_accepted_at = nil

    inviter = create(:user)
    assign :inviter_type, 'User'
    assign :inviter_name, inviter.name(false)

    render
    expect(rendered.include?("Hello #{@invitee.email}")).to eql(true)
  end
end