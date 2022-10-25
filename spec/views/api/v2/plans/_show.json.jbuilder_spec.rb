# frozen_string_literal: true

require 'rails_helper'

describe 'api/v2/plans/_show.json.jbuilder' do
  before do
    Rails.configuration.x.madmp.enable_dmp_id_registration = true

    @plan = create(:plan)
    @data_contact = create(:contributor, data_curation: true, plan: @plan)
    @pi = create(:contributor, investigation: true, plan: @plan)
    @plan.contributors = [@data_contact, @pi]
    create(:identifier, identifiable: @plan)
    @plan.related_identifiers << create(:related_identifier, identifiable: @plan)

    # Create an Api Client and connect it to the Plan
    @client = create(:api_client)
    scheme = create(:identifier_scheme, :for_plans, name: @client.name.downcase)
    @client_identifier = create(:identifier, identifier_scheme: scheme, identifiable: @plan)
    create(:subscription, subscriber: @client, plan: @plan)

    @plan.save
    @plan.reload
    @presenter = Api::V2::PlanPresenter.new(plan: @plan, client: @client)
  end

  describe 'includes all of the DMP attributes' do
    before do
      render partial: 'api/v2/plans/show', locals: { client: @client, plan: @plan }
      @json = JSON.parse(rendered).with_indifferent_access
    end

    it 'includes the :title' do
      expect(@json[:title]).to eql(@plan.title)
    end

    it 'includes the :description' do
      expect(@json[:description]).to eql(@plan.description)
    end

    it 'includes the :language' do
      expected = Api::V1::LanguagePresenter.three_char_code(
        lang: LocaleService.default_locale
      )
      expect(@json[:language]).to eql(expected)
    end

    it 'includes the :created' do
      expect(@json[:created]).to eql(@plan.created_at.to_formatted_s(:iso8601))
    end

    it 'includes the :modified' do
      expect(@json[:modified]).to eql(@plan.updated_at.to_formatted_s(:iso8601))
    end

    it 'includes :ethical_issues' do
      expected = Api::V1::ConversionService.boolean_to_yes_no_unknown(@plan.ethical_issues)
      expect(@json[:ethical_issues_exist]).to eql(expected)
    end

    it 'includes :ethical_issues_description' do
      expect(@json[:ethical_issues_description]).to eql(@plan.ethical_issues_description)
    end

    it 'includes :ethical_issues_report' do
      expect(@json[:ethical_issues_report]).to eql(@plan.ethical_issues_report)
    end

    it 'returns the URL of the plan as the :dmp_id if no DMP ID is defined' do
      expected = Rails.application.routes.url_helpers.api_v2_plan_url(@plan)
      expect(@json[:dmp_id][:type]).to eql('url')
      expect(@json[:dmp_id][:identifier]).to eql(expected)
    end

    it 'includes the :contact' do
      expect(@json[:contact][:mbox]).to eql(@data_contact.email)
    end

    it 'includes the :contributors' do
      emails = @json[:contributor].pluck(:mbox)
      expect(emails.include?(@pi.email)).to be(true)
    end

    # TODO: make sure this is working once the new Cost theme and Currency
    #       question type have been implemented
    it 'includes the :cost' do
      expect(@json[:cost]).to be_nil
    end

    it 'includes the :project' do
      expect(@json[:project].length).to be(1)
    end

    it 'includes the :dataset' do
      expect(@json[:dataset].length).to be(1)
    end

    it 'includes the :dmproadmap_template' do
      expect(@json[:dmproadmap_template].present?).to be(true)
      expect(@json[:dmproadmap_template][:id]).to eql(@plan.template.family_id)
      expect(@json[:dmproadmap_template][:title]).to eql(@plan.template.title)
    end

    it 'includes the :dmproadmap_privacy setting' do
      expect(@json[:dmproadmap_privacy]).to eql(@presenter.visibility)
    end

    it 'includes the :dmproadmap_links PDF :download link' do
      expected = Rails.application.routes.url_helpers.api_v2_plan_url(@plan)
      expect(@json[:dmproadmap_links][:get]).to eql(expected)
      expected = Rails.application.routes.url_helpers.api_v2_plan_url(@plan, format: :pdf)
      expect(@json[:dmproadmap_links][:download]).to eql(expected)
    end

    it 'includes the :dmproadmap_external_system_identifier' do
      expect(@json[:dmproadmap_external_system_identifier]).to eql(@client_identifier.value)
    end

    it 'includes the :dmproadmap_related_identifiers' do
      related = @json[:dmproadmap_related_identifiers].first
      expect(related['work_type']).to eql(@plan.related_identifiers.first.work_type)
      expect(related['type']).to eql(@plan.related_identifiers.first.identifier_type)
      expect(related['descriptor']).to eql(@plan.related_identifiers.first.relation_type)
      expect(related['identifier']).to eql(@plan.related_identifiers.first.value)
    end
  end

  describe 'when the system mints DMP IDs' do
    before do
      scheme = create(:identifier_scheme)
      DmpIdService.expects(:identifier_scheme).at_least(1).returns(scheme)
      @doi = create(:identifier, value: '10.9999/123abc.zy/x23', identifiable: @plan,
                                 identifier_scheme: scheme)
      @plan.reload
      render partial: 'api/v2/plans/show', locals: { client: @client, plan: @plan }
      @json = JSON.parse(rendered).with_indifferent_access
    end

    it 'returns the DMP ID for the :dmp_id if one is present' do
      expect(@json[:dmp_id][:type]).to eql('doi')
      expect(@json[:dmp_id][:identifier]).to eql(@doi.value)
    end
  end
end
