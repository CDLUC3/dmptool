# frozen_string_literal: true

module Dmptool
  module OrgAdmin
    # Helper method that loads the selected Template's email subject/body when the
    # modal window opens for the 'Email Template' function
    module TemplatesController
      # GET /org_admin/templates/132/email (AJAX)
      #------------------------------------------
      # rubocop:disable Metrics/AbcSize
      def email
        @template = Template.find_by(id: params[:id])
        authorize @template

        subject = format(_('A new data management plan (DMP) for the %{org_name} was started for you.'),
                         org_name: @template.org.name)
        # rubocop:disable Layout/LineLength
        body = format(_('An administrator from the %{org_name} has started a new data management plan (DMP) for you. If you have any questions or need help, please contact them at %{org_admin_email}.'),
                      org_name: @template.org.name,
                      org_admin_email: helpers.link_to(
                        @template.org.contact_email, @template.org.contact_email
                      ))
        # rubocop:enable Layout/LineLength

        @template.email_subject = subject if @template.email_subject.blank?
        @template.email_body = body if @template.email_body.blank?

        render '/org_admin/templates/email' # .js.erb'
      end
      # rubocop:enable Metrics/AbcSize

      def preferences
        template = Template.find(params[:id])
        authorize Template
        render 'preferences', locals: {
          partial_path: 'edit',
          template: template,
          output_types: ResearchOutput.output_types,
          preferred_licenses: License.preferred.map { |license| [license.identifier, license.id] },
          licenses: License.selectable.map { |license| [license.identifier, license.id] }
        }
      end

      # GET /org_admin/templates/[:id] # ,
      def save_preferences
        template = Template.find(params[:id])
        authorize Template

        args = preference_params
        args[:customize_output_types] = params[:customize_output_types_sel] != '0'
        args[:customize_licenses] = params[:customize_licenses_sel] != '0'
        Template.transaction do
          template.update(template_output_types: [], licenses: [])
          template.update(args)
        end
        preferences
      end

      private

      def preference_params
        params.require(:template).permit(
          :enable_research_outputs,
          :user_guidance_output_types, :user_guidance_repositories,
          :user_guidance_output_types_title, :user_guidance_output_types_description,
          :user_guidance_metadata_standards, :user_guidance_licenses,
          :customize_output_types, :customize_repositories,
          :customize_metadata_standards, :customize_licenses,
          template_output_types_attributes: %i[id research_output_type],
          licenses_attributes: %i[id]
        )
      end
    end
  end
end
