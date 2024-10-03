# frozen_string_literal: true

require 'base64'
require 'aws-sdk-s3'

# Data migration tasks to port data from DMPTool v5 to the new DMPTool Apollo Server
# located in the https://github.com/CDLUC3/dmsp_backend_prototype repository

# rubocop:disable Naming/VariableNumber
namespace :v6_migration do
  desc 'Generate all of the data migration scripts'
  task generate_all: :environment do
    # Affiliations
    Rake::Task['v6_migration:generate_affiliations'].execute
    # Templates, Sections, Questions
    Rake::Task['v6_migration:generate_templates'].execute
  end

  desc 'Generate affiliations'
  task generate_affiliations: :environment do
    p "Generating SQL statements for Affiliations ..."
    orgs = Org.includes(:registry_orgs).all

    file_name = Rails.root.join('tmp', "v6_orgs_#{Time.now.strftime('%Y-%m-%d_%H%M')}.sql")
    file = File.open(file_name, 'w+')

    sql_insert = 'INSERT INTO `affiliations` (`id`, `provenance`, `name`, `displayName`, searchName`, `funder`, `fundrefId`, `homepage`, `acronyms`, `aliases`, `types`, `logoURI`, `logoName`, `contactName`, `contactEmail`, `ssoEntityId`, `feedbackEnabled`, `feedbackMessage`, `feedbackEmails`, `managed`, `createdById`, `created`, `modifiedById`, `modified`) '
    orgs.each do |org|
      sso_entity_id = org.identifier_for_scheme('shibboleth') if org.shibbolized?
      ror = RegistryOrg.findBy(ror_id: org.identifier_for_scheme('ror'))

      id = ror.present? ? ror.ror_id : "https://dmptool.org/affiliations/#{SecureRandom.hex(4)}"
      provenance = ror.present? ? 'ROR' : 'DMPTOOL'
      name = ror.present? ? ror.name.split(' (').first : org.name.split(' (').first
      displayName = ror.present? ? ror.name : org.name
      domain_parts = ror.present? ror.home_page.split('.').reverse
      domain = "#{domain_parts[1]}.#{domain_parts[0]}" if domain_parts.length >= 2
      searchName = "#{[name, domain].join(' | ')} | #{acronyms.join(' | ')} #{aliases.join(' | ')}"
      funder = org.funder? || ror&.fundref_id.present?
      fundref_id = ror&.fundref_id
      homepage = ror.present? ? ror.home_page : org.target_url
      acronyms = ror.present? ? ror.acronyms : []
      aliases = ror.present? ? ror.aliases : [ ]
      types = ror.present? ? ror.types : ["Education"]

      # TODO: Figure out how to handle logos
      logo_uri = nil #logo_uid if org.logo.present?
      logo_name = nil

      contact_name = org.contact_name
      contact_email = org.contact_email
      feedback_enabled = org.feedback_enabled
      feedback_msg = org.feedback_msg
      managed = org.managed

      sql = "(SELECT '#{id}', '#{provenance}', '#{name}', '#{displayName}', '#{searchName}', #{funder ? '1' : '0'}, '#{fundref_id}', '#{homepage}', '#{acronyms.to_json}', '#{aliases.to_json}', '#{types.to_json}', NULL, NULL, '#{contact_name}', '#{contact_email}', '#{sso_entity_id}', #{feedback_enabled}, '#{feedback_msg}', '', #{managed}, `users`.`id`, CURDATE(), `users`.`id`, CURDATE() FROM users WHERE email = 'super@example.com')"
      file.write("#{sql_insert} #{sql};")
      file.write "INSERT INTO `affiliations_email_domains` (`email`, `affiliationId`, `createdById`, `created`, `modifiedById`, `modified`) (SELECT '#{domain}', `affiliations`.`id`, `affiliations`.`createdById`, CURDATE(), `affiliations`.`modifiedById`, CURDATE() FROM `affiliations` WHERE `affiliations`.`id` = '#{id}');"

      if !org.links.nil? && org.links.any? && org.links['org'].present?
        org.links['org'].each do |link|
          next unless link['link'].present?

          file.write "INSERT INTO `affiliations_links` (`url`, `text`, `affiliationId`, `createdById`, `created`, `modifiedById`, `modified`) (SELECT '#{link['link']}', '#{link['text']}', `affiliations`.`id`, `affiliations`.`createdById`, CURDATE(), `affiliations`.`modifiedById`, CURDATE() FROM `affiliations` WHERE `affiliations`.`id` = '#{id}');"
        end
      end
      file.write ''
    end

    file.close
    p "DONE. SQL written to: #{file_name}"
  end

  desc 'Generate mock/test users for each Org that has a published template'
  task generate_mock_admins: :environment do
    p "Generating SQL statements for Mock Template Admins ..."
    orgs = RegistryOrg.known
    templates = Template.published.where(org_id: orgs.map(&:org_id), customization_of: nil)

    file_name = Rails.root.join('tmp', "v6_users_#{Time.now.strftime('%Y-%m-%d_%H%M')}.sql")
    file = File.open(file_name, 'w+')

    file.write "# "
    file.write "# MOCK ADMIN USERS"
    file.write "# ================================================================="

    already_done = []
    templates.each do |tmplt|
      org = orgs.select { |ror| ror.org_id == tmplt.org_id }&.first
      next if org.nil?

      domain = org.name.split(' (')&.last&.gsub(')', '').strip
      unless already_done.include?(domain)
        file.write "INSERT INTO `users` (`email`, `affiliationId`, `password`, `givenName`, `surName`, `role`) VALUES ('admin@#{domain}', '#{org.ror_id}', '$2a$10$f3wCBdUVt/2aMcPOb.GX1OBO9WMGxDXx5HKeSBBnrMhat4.pis4Pe', '#{org.name.split(" (").first.strip} Admin', 'Test User', 'ADMIN'); "
        already_done << domain
      end
    end
    file.close
    p "DONE. SQL written to: #{file_name}"
  end

  desc 'Generate all of the template migrations'
  task generate_templates: :environment do
    p "Generating SQL statements for published templates ..."
    orgs = RegistryOrg.known
    templates = Template.published.where(org_id: orgs.map(&:org_id), customization_of: nil)

    file_name = Rails.root.join('tmp', "v6_templates_#{Time.now.strftime('%Y-%m-%d_%H%M')}.sql")
    file = File.open(file_name, 'w+')

    question_formats = QuestionFormat.all

    file.write "# "
    file.write "# TEMPLATES"
    file.write "# ================================================================="

    templates.each do |tmplt|
      tmplt_title = safe_text(tmplt.title)
      tmplt_desc = safe_text(tmplt.description)

      # Skip (for now) if the org is not in ROR
      org = orgs.select { |ror| ror.org_id == tmplt.org_id }&.first
      next if org.nil?

      file.write ''
      file.write "INSERT INTO `templates` (`name`, `description`, `ownerId`, `visibility`, `currentVersion`, `isDirty`, `bestPractice`, `createdById`, `created`, `modifiedById`, `modified`) (SELECT '#{tmplt_title}', '#{tmplt_desc}', '#{org.ror_id}', '#{tmplt.visibility == 1 ? "PUBLIC" : "PRIVATE"}', 'v#{tmplt.version + 1}', 0, #{tmplt.is_default ? 1 : 0}, `users`.`id`, '#{tmplt.created_at.utc.strftime('%Y-%m-%d %H:%M:%S')}', `users`.`id`, '#{tmplt.updated_at.utc.strftime('%Y-%m-%d %H:%M:%S')}' FROM `users` WHERE `affiliationId` = '#{org.ror_id}' AND `role` = 'ADMIN'); "
      file.write "INSERT INTO `versionedTemplates` (`templateId`, `active`, `version`, `versionType`, `versionedById`, `comment`, `name`, `description`, `ownerId`, `visibility`, `bestPractice`, `created`, `modified`, `createdById`, `modifiedById`) (SELECT `templates`.`id`, 1, `templates`.`currentVersion`, 'PUBLISHED', (SELECT id FROM users WHERE email = 'super@example.com' LIMIT 1), 'Initial migration from the old DMPTool system.', `templates`.`name`, `templates`.`description`, `templates`.`ownerId`, `templates`.`visibility`, `templates`.`bestPractice`, `templates`.`created`, `templates`.`modified`, `templates`.`createdbyId`, `templates`.`modifiedById` FROM `templates` WHERE SUBSTRING(`templates`.`name`, 1, 100) = '#{tmplt_title[0..101]}' AND `templates`.`ownerId` = '#{org.ror_id}' LIMIT 1); "
      file.write ''

      # Fetch the phase ids
      phase_ids = Phase.where(template_id: tmplt.id).pluck(:id)

      # Fetch any org guidance that we can hook onto the sections
      guidance = Guidance.includes(:guidance_group, :themes)
                         .joins(:guidance_group)
                         .where(guidance_group: [org_id: org.id])

      guidance_hash = guidance.map do |rec|
        tags = themes_to_tags(rec.themes)
        { tags: tags, text: safe_text(rec.text) }
      end

      # Fetch the sections
      file.write ''
      sections = Section.where(phase_id: phase_ids)
      sections.each do |section|
        tags = tags_from_title(section.title)
        guidance = guidance_hash.select { |guide| guide[:tags] & tags }.join
        guidance = '' if guidance.nil?
        section_title = safe_text(section.title)
        section_desc = safe_text(section.description)
        puts "No tags found for Section title: #{section_title}" if tags.empty?

        file.write "INSERT INTO `sections` (`templateId`, `name`, `introduction`, `requirements`, `guidance`, `displayOrder`, `isDirty`, `createdById`, `created`, `modifiedById`, `modified`) (SELECT `templates`.`id`, '#{section_title}', '#{section_desc}', '', '#{guidance}', #{section.number}, 0, `templates`.`createdById`, `templates`.`created`, `templates`.`modifiedById`, `templates`.`modified` FROM `templates` WHERE `ownerId` = '#{org.ror_id}' AND SUBSTRING(`name`, 1, 100) = '#{tmplt_title[0..101]}'); "
        file.write "INSERT INTO `versionedSections` (`sectionId`, `versionedTemplateId`, `name`, `introduction`, `requirements`, `guidance`, `displayOrder`, `createdById`, `created`, `modifiedById`, `modified`) (SELECT `sections`.`id`, (SELECT `versionedTemplates`.`id` FROM `versionedTemplates` WHERE `versionedTemplates`.`templateId` = `templates`.`id`), '#{section_title}', '#{section_desc}', '', '#{guidance}', #{section.number}, `sections`.`createdById`, `sections`.`created`, `sections`.`modifiedById`, `sections`.`modified` FROM `templates` INNER JOIN `sections` ON `templates`.`id` = `sections`.`templateId` WHERE SUBSTRING(`sections`.`name`, 1, 100) = '#{section_title[0..101]}' AND `sections`.`displayOrder` = #{section.number} AND `templates`.`ownerId` = '#{org.ror_id}' AND SUBSTRING(`templates`.`name`, 1, 100) = '#{tmplt_title[0..101]}' LIMIT 1); "
        tags.each do |tag|
          file.write "INSERT INTO `sectionTags` (`sectionId`, `tagId`, `createdById`, `modifiedById`) (SELECT `sections`.`id`, (SELECT `tags`.`id` FROM `tags` WHERE `tags`.`name` = '#{tag}'), `sections`.`createdById`, `sections`.`modifiedById` FROM `templates` INNER JOIN `sections` ON `templates`.`id` = `sections`.`templateId` WHERE SUBSTRING(`sections`.`name`, 1, 100) = '#{section_title[0..101]}' AND `templates`.`ownerId` = '#{org.ror_id}' AND SUBSTRING(`templates`.`name`, 1, 100) = '#{tmplt_title[0..101]}' LIMIT 1); "
        end
        file.write ''

        # Now process the questions
        questions = Question.where(section_id: section.id)
        questions.each do |question|
          question_text = safe_text(question.text)
          question_type = question_type(question_formats.select {|typ| typ.id = question.question_format_id }.first)
          # See if there is any question level guidance
          guidance_text = Annotation.where(question_id: question.id, type: 1).map { |g| safe_text(g.text) }.join('<br/>')
          # See if there is a sample answer
          sample_text = Annotation.where(question_id: question.id, type: 0).map { |st| safe_text(st.text) }.join('<br/>')
          file.write "INSERT INTO `questions` (`templateId`, `sectionId`, `displayOrder`, `isDirty`, `questionTypeId`, `questionText`, `guidanceText`, `sampleText`, `required`, `createdById`, `created`, `modifiedById`, `modified`) (SELECT `sections`.`templateId`, `sections`.`id`, #{question.number}, false, (SELECT `questionTypes`.`id` FROM `questionTypes` WHERE `questionTypes`.`name` = '#{question_type}'), '#{question_text}', '#{guidance_text}', '#{sample_text}', false, `sections`.`createdById`, `sections`.`created`, `sections`.`modifiedById`, `sections`.`modified` FROM `sections` INNER JOIN `templates` ON `sections`.`templateId` = `templates`.`id` WHERE SUBSTRING(`sections`.`name`, 1, 100) = '#{section_title[0..101]}' AND `sections`.`displayOrder` = #{section.number} AND SUBSTRING(`templates`.`name`, 1, 100) = '#{tmplt_title[0..101]}' AND `templates`.`ownerId` = '#{org.ror_id}');"
          file.write "INSERT INTO `versionedQuestions` (`questionId`, `versionedTemplateId`, `versionedSectionId`, `questionTypeId`, `questionText`, `requirementText`, `guidanceText`, `sampleText`, `displayOrder`, `required`, `createdById`, `created`, `modifiedById`, `modified`) (SELECT `questions`.`id`, (SELECT `versionedTemplates`.`id` FROM `versionedTemplates` WHERE `versionedTemplates`.`templateId` = `templates`.`id` ORDER BY `versionedTemplates`.`created` DESC LIMIT 1), (SELECT `versionedSections`.`id` FROM `versionedSections` WHERE `versionedSections`.`sectionId` = `sections`.`id` AND `versionedSections`.`displayOrder` = `sections`.`displayOrder` ORDER BY `versionedSections`.`created` DESC LIMIT 1), (SELECT `questionTypes`.`id` FROM `questionTypes` WHERE `questionTypes`.`name` = '#{question_type}'), '#{question_text}', '', '#{guidance_text}', '#{sample_text}', #{question.number}, false, `sections`.`createdById`, `sections`.`created`, `sections`.`modifiedById`, `sections`.`modified` FROM `questions` INNER JOIN `sections` ON `questions`.`sectionId` = `sections`.`id` INNER JOIN `templates` ON `questions`.`templateId` = `templates`.`id` WHERE SUBSTRING(`questions`.`questionText`, 1, 250) = '#{question_text[0..251]}' AND SUBSTRING(`sections`.`name`, 1, 100) = '#{section_title[0..101]}' AND `sections`.`displayOrder` = #{section.number} AND `templates`.`ownerId` = '#{org.ror_id}' AND SUBSTRING(`templates`.`name`, 1, 100) = '#{tmplt_title[0..101]}' LIMIT 1); "
        end
      end

      file.write ''
    end

    file.close
    p "DONE. SQL written to: #{file_name}"
  end

  def safe_text(text)
    text&.strip
        &.gsub("'"){"\\'"}
        &.gsub(/\r/," ")
        &.gsub(/\n/," ")
  end

  def tags_from_title(title)
    prepped = title.downcase.strip
    tags = []
    tags << 'Data description' if prepped.include?('description') ||
                                  prepped.include?('produced') ||
                                  prepped.include?('products') ||
                                  prepped.include?('sources') ||
                                  prepped.include?('data format') ||
                                  prepped.include?('data type') ||
                                  prepped.include?('sample type') ||
                                  prepped.include?('data volume') ||
                                  prepped.include?('data input') ||
                                  prepped.include?('data summary') ||
                                  prepped.include?('produzidos') ||
                                  prepped.include?('materials') ||
                                  prepped.include?('research outputs') ||
                                  prepped.include?('attributes') ||
                                  prepped.include?('computational environment')

    tags << 'Data organization & documentation' if prepped.include?('documentation') ||
                                                   prepped.include?('metadata') ||
                                                   prepped.include?('metadados') ||
                                                   prepped.include?('organization') ||
                                                   prepped.include?('version control') ||
                                                   prepped.include?('standard') ||
                                                   prepped.include?('documentação') ||
                                                   prepped.include?('methodology')

    tags << 'Security & privacy' if prepped.include?('security') ||
                                    prepped.include?('privacy') ||
                                    prepped.include?('protection') ||
                                    prepped.include?(' legal') ||
                                    prepped.include?('copyright') ||
                                    prepped.include?('intellectual property') ||
                                    prepped.include?('proprietary') ||
                                    prepped.include?('propriedade intelectual') ||
                                    prepped.include?('restriction') ||
                                    prepped.include?('secondary use') ||
                                    prepped.include?('secure ')

    tags << 'Ethical considerations' if prepped.include?('ethic') ||
                                        prepped.include?('policy') ||
                                        prepped.include?('policies') ||
                                        prepped.include?('legal') ||
                                        prepped.include?('indigenous') ||
                                        prepped.include?('obligation') ||
                                        prepped.include?('disposal') ||
                                        prepped.include?('bias') ||
                                        prepped.include?('legais')

    tags << 'Training & support' if prepped.include?('training') ||
                                    prepped.include?('support') ||
                                    prepped.include?('documenting') ||
                                    prepped.include?('contact ') ||

    tags << 'Data sharing' if prepped.include?('share ') ||
                              prepped.include?('sharing') ||
                              prepped.include?('reuse ') ||
                              prepped.include?('re-use') ||
                              prepped.include?('audience') ||
                              prepped.include?('access') ||
                              prepped.include?('publication') ||
                              prepped.include?('storing') ||
                              prepped.include?('reutilização') ||
                              prepped.include?('dissemination') ||
                              prepped.include?('compartilhamento')

    tags << 'Data storage & backup' if prepped.include?('storage') ||
                                       prepped.include?('backup') ||
                                       prepped.include?('back-up') ||
                                       prepped.include?('repositor') ||
                                       prepped.include?('preserv') ||
                                       prepped.include?('management') ||
                                       prepped.include?('retention') ||
                                       prepped.include?('armazenados') ||
                                       prepped.include?('archiving')

    tags << 'Data quality & integrity' if prepped.include?('quality') ||
                                          prepped.include?('integrity') ||
                                          prepped.include?('adherence') ||
                                          prepped.include?('managing') ||
                                          prepped.include?('monitoring') ||
                                          prepped.include?('validation')

    tags << 'Roles & responsibilities' if prepped.include?(' role') ||
                                          prepped.include?('responsibilit') ||
                                          prepped.include?('collaborator') ||
                                          prepped.include?('administration') ||
                                          prepped.include?('author') ||
                                          prepped.include?('papéis') ||
                                          prepped.include?('responsabilidade')

    tags << 'Budget' if prepped.include?('budget') ||
                        prepped.include?('funding') ||
                        prepped.include?(' cost')

    tags << 'Data collection' if prepped.include?('collection') ||
                                 prepped.include?('collecting') ||
                                 prepped.include?('protocol') ||
                                 prepped.include?('software') ||
                                 prepped.include?('analysis') ||
                                 prepped.include?('third party') ||
                                 prepped.include?('generation') ||
                                 prepped.include?('assessment') ||
                                 prepped.include?('gerenciamento') ||
                                 prepped.include?('recolhidos') ||
                                 prepped.include?('pre-cruise') ||
                                 prepped.include?('data synthesis') ||
                                 prepped.include?('geração') ||
                                 prepped.include?('coleta')
    tags
  end

  def themes_to_tags(themes)
    tags = []
    themes.each do |theme|
      theme = theme.downcase.strip
      tags << 'Budget' if theme == 'budget'
      tags << 'Data collection' if theme == 'data collection'
      tags << 'Data description' if theme == 'data description'
      tags << 'Data description' if theme == 'data format'
      tags << 'Data description' if theme == 'data volume'
      tags << 'Data storage & backup' if theme == 'data repository'
      tags << 'Data sharing' if theme == 'data sharing'
      tags << 'Security & privacy' if theme == 'ethics & privacy'
      tags << 'Ethical considerations' if theme == 'ethics & privacy'
      tags << 'Security & privacy' if theme == 'intellectual property rights'
      tags << 'Data organization & documentation' if theme == 'metadata & documentation'
      tags << 'Data storage & backup' if theme == 'preservaction'
      tags << 'Data storage & backup' if theme == 'storage & security'
      tags << 'Security & privacy' if theme == 'storage & security'
      tags << 'Roles & responsibilities' if theme == 'roles & responsibilities'
      tags << 'Data sharing' if theme == 'related policies'
      tags << 'Security & privacy' if theme == 'related policies'
    end
    tags.uniq
  end

  # Question type mapping (Check new system to make sure names are correct!)
  def question_type(type_in)
    case type_in.title&.downcase&.strip
    when 'text field'
      'Text Field'
    when 'radio button'
      'Radio Buttons'
    when 'check box'
      'Check Boxes'
    when 'dropdown'
      'Select Box'
    when 'multi select box'
      'Multi-select Box'
    else
      'Rich Text Editor'
    end
  end
end