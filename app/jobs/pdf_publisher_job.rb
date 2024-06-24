# frozen_string_literal: true

# This Job sends a notification (the JSON version of the Plan) out to the specified
# subscriber.
class PdfPublisherJob < ApplicationJob
  queue_as :default

  def perform(obj:)
    if obj.is_a?(Plan)
      ac = ApplicationController.new # ActionController::Base.new
      html = ac.render_to_string(template: 'branded/shared/export/pdf', layout: false, locals: _prep_plan_for_pdf(plan: obj))

      # limit the filename length to 100 chars. Windows systems have a MAX_PATH allowance
      # of 255 characters, so this should provide enough of the title to allow the user
      # to understand which DMP it is and still allow for the file to be saved to a deeply
      # nested directory
      file_name = Zaru.sanitize!(obj.title).strip.gsub(/\s+/, '_')[0, 100]
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

      _process_narrative_file(obj: obj, file_name: file_name, file: pdf)
    elsif obj.is_a?(Draft)
      return false unless obj.narrative.attached?

      # obj.narrative.open { |file| Rails.logger.info "FILE: #{file.path}"; _process_narrative_file(obj: obj, file_name: file.path, file: file) }

      # Pull the PDF from ActiveStorage and save to a tmp file for upload to the DMPHub
      pdf = obj.narrative.download
      file_name = Zaru.sanitize!(obj.metadata['dmp']['title']).strip.gsub(/\s+/, '_')[0, 100]
      _process_narrative_file(obj: obj, file_name: file_name, file: pdf)
    elsif obj.is_a?(Template)
      @formatting = {
        font_face: 'Tinos, serif',
        font_size: '11',
        margin: { top: '20', right: '20', bottom: '20', left: '20' }
      }
      @template = obj
      file_name = @template.title.gsub(/[^a-zA-Z\d\s]/, '').tr(' ', '_')
      file_name = "#{file_name}_v#{@template.version}"
      ac = ApplicationController.new # ActionController::Base.new
      html = ac.render_to_string(template: '/template_exports/template_export', layout: false,
                                 locals: { template: @template, formatting: @formatting})

      grover_options = {
        margin:  {
          top: '96px',
          right: '25px',
          bottom: '79px',
          left: '96px'
        },
        display_url: Rails.configuration.x.hosts.first || 'http://localhost:3000/'#,
      }

      pdf = Grover.new(html, **grover_options).to_pdf
      _process_narrative_file(obj: @template, file_name: file_name, file: pdf)
    else
      Rails.logger.error 'PdfPublisherJob.perform expected a Plan!'
      false
    end
  rescue StandardError => e
    # Something went terribly wrong, so note it in the logs since this runs outside the
    # regular Rails thread that the application is using
    Rails.logger.error "PdfPublisherJob.perform failed for Plan: #{obj&.id} - #{e.message}"
    Rails.logger.error e.backtrace
  end

  private

  # Build a copy of the narrative PDF and then send it to the DmpIdService
  def _process_narrative_file(obj:, file_name:, file:)
    # Write the file to the tmp directory for the upload process
    pdf_file_name = Rails.root.join('tmp', "#{file_name}.pdf")
    pdf_file = File.open(pdf_file_name, 'wb') { |tmp| tmp << file }
    pdf_file.close

    # Send it to DMPHub if it has a DMP ID and store it in ActiveStorage if it is publicly visible
    has_dmp_id = !obj.is_a?(Template) && obj.dmp_id.present?
    if (obj.is_a?(Plan) && obj.publicly_visible?) || obj.is_a?(Template)
      _publish_locally(obj: obj, pdf_file_path: pdf_file_name, pdf_file_name: "#{file_name}.pdf")
    end

    _publish_to_dmphub(obj: obj, pdf_file_name: pdf_file_name) if has_dmp_id

    # Delete the tmp file
    File.delete(pdf_file_name)
  end

  # Publish the PDF to local ActiveStorage
  def _publish_locally(obj:, pdf_file_path:, pdf_file_name:)
    key = obj.is_a?(Template) ? 'templates' : 'narratives'

    # Get rid of the existing one (if applicable)
    obj.narrative.purge if obj.narrative.attached?

    obj.narrative.attach(key: "#{key}/#{obj.id}.pdf", io: File.open(pdf_file_path), filename: pdf_file_name,
                          content_type: 'application/pdf')
    # Skip updating the timestamps so that it does not re-trigger the callabcks again!
    if obj.save(touch: false)
      Rails.logger.info "PdfPublisherJob._publish_locally successfully published PDF for #{obj.id} at #{pdf_file_path}"
      obj.publisher_job_status = 'success'
      obj.save(touch: false)
    else
      Rails.logger.error 'PdfPublisherJob._publish_locally failed to store file in ActiveStorage!'
      obj.publisher_job_status = 'failed'
      obj.save(touch: false)
    end
  end

  # Publish the PDF to the DMPHub
  def _publish_to_dmphub(obj:, pdf_file_name:)
    hash = DmpIdService.publish_pdf(obj: obj, pdf_file_name: pdf_file_name)
    if hash.is_a?(Hash) && hash[:narrative_url].present?
      Rails.logger.info "PdfPublisherJob._publish_to_dmphub successfully published PDF for #{obj.dmp_id} at #{hash[:narrative_url]}"
      # Skip updating the timestamps so that it does not re-trigger the callabcks again!
      obj.publisher_job_status = 'success'
      obj.save(touch: false)
    else
      Rails.logger.error 'PdfPublisherJob._publish_to_dmphub did not return a narrtive URL!'
      # Skip updating the timestamps so that it does not re-trigger the callabcks again!
      obj.publisher_job_status = 'failed'
      obj.save(touch: false)
    end
  end

  # rubocop:disable Metrics/AbcSize
  def _prep_plan_for_pdf(plan:)
    return {} if plan.blank?

    {
      plan: plan,
      public_plan: plan.publicly_visible?,
      hash: plan.as_pdf(nil, true),
      formatting: plan.settings(:export).formatting || plan.template.settings(:export).formatting,
      selected_phase: plan.phases.order('phases.updated_at DESC').first
    }
  end
  # rubocop:enable Metrics/AbcSize
end
