# frozen_string_literal: true

# locals: plan

plan = plan.first if plan.is_a?(Array)
@client = client if @client.blank?

json.ignore_nil!

presenter = Api::V2::PlanPresenter.new(plan: plan, client: @client)
# A JSON representation of a Data Management Plan in the
# RDA Common Standard format
json.title plan.title
json.description plan.description
json.language Api::V1::LanguagePresenter.three_char_code(
  lang: LocaleService.default_locale
)
json.created plan.created_at.to_formatted_s(:iso8601)
json.modified plan.updated_at.to_formatted_s(:iso8601)

json.ethical_issues_exist Api::V2::ConversionService.boolean_to_yes_no_unknown(plan.ethical_issues)
json.ethical_issues_description plan.ethical_issues_description
json.ethical_issues_report plan.ethical_issues_report

id = presenter.identifier
if id.present?
  json.dmp_id do
    json.partial! 'api/v2/identifiers/show', identifier: id
  end
end

if presenter.data_contact.present?
  json.contact do
    json.partial! 'api/v2/contributors/show', contributor: presenter.data_contact,
                                              is_contact: true
  end
end

unless @minimal
  if presenter.contributors.any?
    json.contributor presenter.contributors do |contributor|
      json.partial! 'api/v2/contributors/show', contributor: contributor,
                                                is_contact: false
    end
  end

  if presenter.costs.any?
    json.cost presenter.costs do |cost|
      json.partial! 'api/v2/plans/cost', cost: cost
    end
  end

  json.project [plan] do |pln|
    json.partial! 'api/v2/plans/project', plan: pln
  end

  outputs = plan.research_outputs.any? ? plan.research_outputs : [plan]

  json.dataset outputs do |output|
    json.partial! 'api/v2/datasets/show', output: output
  end

  # DMPRoadmap extensions to the RDA common metadata standard
  json.dmproadmap_template do
    json.id plan.template.family_id
    json.title plan.template.title
  end

  # If the plan was created via the API and the external system provided an identifier,
  # return that value
  json.dmproadmap_external_system_identifier presenter.external_system_identifier&.value

  # Any related identifiers known by the DMPTool
  related_identifiers = plan.related_identifiers.map { |r_id| r_id.clone }

  # Add the PDF download link as a related identifier for the DMP ID if the plan is public
  if plan.visibility == 'publicly_visible'
    related_identifiers << RelatedIdentifier.new(identifier_type: :url,
                                                 relation_type: :is_metadata_for,
                                                 value: presenter.download_pdf_link)
  end

  if related_identifiers.any?
    json.dmproadmap_related_identifiers related_identifiers do |related|
      next unless related.value.present? && related.relation_type.present?

      json.descriptor related.relation_type
      json.type related.identifier_type
      json.identifier related.value.start_with?('http') ? related.value : "https://doi.org/#{related.value}"
      json.work_type related.relation_type == 'is_metadata_for' ? 'output_management_plan' : related.work_type
    end
  end

  json.dmproadmap_privacy presenter.visibility

  # TODO: Refactor as we determine how best to fully implement sponsors
  if plan.template&.sponsor.present?
    json.dmproadmap_research_facilities [plan.template&.sponsor] do |sponsor|
      json.name sponsor.name
      json.type 'field_station'

      ror = sponsor.identifier_for_scheme(scheme: 'ror')
      if ror.present?
        json.facility_id do
          json.partial! 'api/v2/identifiers/show', identifier: ror
        end
      end
    end
  end

  # DMPHub extension to send all callback addresses for interested subscribers for changes to the DMP
  # json.dmphub_subscribers presenter.subscriptions
end

# DMPRoadmap specific links to perform special actions like downloading the PDF
json.dmproadmap_links presenter.links
