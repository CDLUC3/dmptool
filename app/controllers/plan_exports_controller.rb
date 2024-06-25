# frozen_string_literal: true

# Controller for the Plan Download page
class PlanExportsController < ApplicationController
  after_action :verify_authorized

  include ConditionsHelper

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def show
    @plan = Plan.includes(:answers, { template: { phases: { sections: :questions } } })
                .find(params[:plan_id])

    if privately_authorized? && export_params[:form].present?
      skip_authorization
      @show_coversheet          = export_params[:project_details].present?

      # DMPTool customization
      # ----------------------
      # Remove single :question_headings and replace with separate :section_headings and
      # :question_text
      #
      # @show_sections_questions  = export_params[:question_headings].present?
      @show_sections            = export_params[:section_headings].present?
      @show_questions           = export_params[:question_text].present?

      @show_unanswered          = export_params[:unanswered_questions].present?
      @show_custom_sections     = export_params[:custom_sections].present?
      @show_research_outputs    = export_params[:research_outputs].present?
      @show_related_identifiers = export_params[:related_identifiers].present?
      @formatting               = export_params[:formatting]
      @formatting               = @plan.settings(:export)&.formatting if @formatting.nil?
      @public_plan              = false
    elsif publicly_authorized?
      skip_authorization
      @show_coversheet          = true

      # DMPTool customization
      # ----------------------
      # Remove single :question_headings and replace with separate :section_headings and :question_text
      #
      # @show_sections_questions  = true
      @show_sections            = true
      @show_questions           = true

      @show_unanswered          = true
      @show_custom_sections     = true
      @show_research_outputs    = @plan.research_outputs&.any? || false
      @show_related_identifiers = @plan.related_identifiers&.any? || false
      @formatting               = @plan.settings(:export)&.formatting
      @formatting               = Settings::Template::DEFAULT_SETTINGS if @formatting.nil?
      @public_plan              = true

    else
      raise Pundit::NotAuthorizedError, _('are not authorized to view that plan')
    end

    @from_public_plans_page   = export_params[:pub].to_s.downcase.strip == 'true'
    @hash           = @plan.as_pdf(current_user, @show_coversheet)
    @formatting     = export_params[:formatting] || @plan.settings(:export).formatting
    if params.key?(:phase_id) && params[:phase_id].length.positive?
      # order phases by phase number asc
      @hash[:phases] = @hash[:phases].sort_by { |phase| phase[:number] }
      if params[:phase_id] == 'All'
        @hash[:all_phases] = true
      else
        @selected_phase = @plan.phases.find(params[:phase_id])
      end
    else
      @selected_phase = @plan.phases.order('phases.updated_at DESC')
                             .detect { |p| p.visibility_allowed?(@plan) }
    end

    # Bug fix in the event that there was no phase with visibility_allowed
    @selected_phase = @plan.phases.order('phases.updated_at DESC').first if @selected_phase.blank?

    # Added contributors to coverage of plans.
    # Users will see both roles and contributor names if the role is filled
    @hash[:data_curation] = Contributor.where(plan_id: @plan.id).data_curation
    @hash[:investigation] = Contributor.where(plan_id: @plan.id).investigation
    @hash[:pa] = Contributor.where(plan_id: @plan.id).project_administration
    @hash[:other] = Contributor.where(plan_id: @plan.id).other

    respond_to do |format|
      format.html { show_html }
      format.csv  { show_csv }
      format.text { show_text }
      format.docx { show_docx }
      format.pdf  { show_pdf }
      format.json { show_json }
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  private

  def show_html
    render layout: false
  end

  def show_csv
    send_data @plan.as_csv(current_user, @show_questions,
                           @show_unanswered,
                           @selected_phase,
                           @show_custom_sections,
                           @show_coversheet,
                           @show_research_outputs,
                           @show_related_identifiers),
              filename: "#{file_name}.csv"
  end

  def show_text
    send_data render_to_string(partial: 'shared/export/plan_txt'),
              filename: "#{file_name}.txt"
  end

  def show_docx
    # Using and optional locals_assign export_format
    render docx: "#{file_name}.docx",
           content: clean_html_for_docx_creation(render_to_string(partial: 'shared/export/plan',
                                                                  locals: { export_format: 'docx' }))
  end

  def show_pdf

    # Grover experiment
    begin
      # If we have a copy of the PDF stored in ActiveStorage, just retrieve that one instead of generating it
      redirect_to rails_blob_path(@plan.narrative, disposition: "attachment") and return if @plan.narrative.present? &&
                                                                                            @from_public_plans_page

      html = render_to_string(partial: '/shared/export/plan')

      grover_options = {
        margin:  {
          top: @formatting.fetch(:margin, {}).fetch(:top, '25px'),
          right: @formatting.fetch(:margin, {}).fetch(:right, '25px'),
          bottom: @formatting.fetch(:margin, {}).fetch(:bottom, '25px'),
          left: @formatting.fetch(:margin, {}).fetch(:left, '25px')
        },
        display_url: Rails.configuration.x.hosts.first || 'http://localhost:3000/'#,
      }

      pdf = Grover.new(html, **grover_options).to_pdf
      send_data(pdf, filename: "#{file_name}.pdf", type: 'application/pdf')
    rescue StandardError => e
      Rails.logger.error("Unable to generate PDF! #{e.message}")
      Rails.logger.error(e.backtrace)
      path = @from_public_plans_page ? public_plans_path : download_plan_path(@plan)
      redirect_to path, alert: 'Unable to generate a PDF at this time.'
    end
  end

  def show_json
    json = render_to_string(partial: '/api/v2/plans/show',
                            locals: { plan: @plan, client: current_user })
    json = "{\"dmp\":#{json}}"
    render json: json
  end

  def file_name
    # Sanitize bad characters and replace spaces with underscores
    ret = @plan.title
    ret = ret.strip.gsub(/\s+/, '_')
    ret = ret.delete('"')
    ret = ActiveStorage::Filename.new(ret).sanitized
    # limit the filename length to 100 chars. Windows systems have a MAX_PATH allowance
    # of 255 characters, so this should provide enough of the title to allow the user
    # to understand which DMP it is and still allow for the file to be saved to a deeply
    # nested directory
    ret[0, 100]
  end

  def publicly_authorized?
    PublicPagePolicy.new(current_user, @plan).plan_organisationally_exportable? ||
      PublicPagePolicy.new(current_user, @plan).plan_export?
  end

  def privately_authorized?
    if current_user.present?
      PlanPolicy.new(current_user, @plan).export?
    else
      false
    end
  end

  def export_params
    # DMPTool customization
    # ----------------------
    # Remove single :question_headings and replace with separate :section_headings and :question_text
    #
    params.require(:export)
          .permit(:form, :project_details, :section_headings, :question_text, :unanswered_questions,
                  :custom_sections, :research_outputs, :related_identifiers, :pub,
                  formatting: [:font_face, :font_size, { margin: %i[top right bottom left] }])
  end

  # A method to deal with problematic text combinations
  # in html that break docx creation by htmltoword gem.
  def clean_html_for_docx_creation(html)
    # Replaces single backslash \ with \\ with gsub.
    html.gsub('\\', '\&\&')
  end
end
