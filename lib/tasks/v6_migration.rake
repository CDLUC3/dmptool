# frozen_string_literal: true

require 'base64'
require 'aws-sdk-s3'

# Data migration tasks to port data from DMPTool v5 to the new DMPTool Apollo Server
# located in the https://github.com/CDLUC3/dmsp_backend_prototype repository

# rubocop:disable Naming/VariableNumber
namespace :v6_migration do
  desc 'Generate all of the data migration scripts'
  task generate_all: :environment do
    # Templates, Sections, Questions
    Rake::Tasks['v6_migration:generate_mock_users'].execute
    Rake::Task['v6_migration:generate_templates'].execute
    Rake::Task['v6_migration:generate_sections'].execute

  end

  desc 'Generate mock/test users for each Org that has a published template'
  task generate_mock_users: :environment do
    p ""
    p "MOCK ADMIN USERS"
    p "================================================================="
    orgs = RegistryOrg.known
    templates = Template.published.where(org_id: orgs.map(&:org_id), customization_of: nil)

    templates.each do |tmplt|
      org = orgs.select { |ror| ror.org_id == tmplt.org_id }&.first
      next if org.nil?

      domain = org.name.split(' (')&.last&.gsub(')', '').strip
      p "INSERT INTO `users` (`email`, `affiliationId`, `password`, `givenName`, `surName`, `role`) VALUES ('admin@#{domain}', '#{org.ror_id}', '$2a$10$f3wCBdUVt/2aMcPOb.GX1OBO9WMGxDXx5HKeSBBnrMhat4.pis4Pe', '#{org.name.split(" (").first.strip} Admin', 'Test User', 'ADMIN');"
    end
  end

  desc 'Generate all of the template migrations'
  task generate_templates: :environment do
    p ""
    p "TEMPLATES"
    p "================================================================="
    orgs = RegistryOrg.known
    templates = Template.published.where(org_id: orgs.map(&:org_id), customization_of: nil)

    templates.each do |tmplt|
      org = orgs.select { |ror| ror.org_id == tmplt.org_id }&.first
      next if org.nil?

      p '---'
      p "INSERT INTO `templates` (`name`, `ownerId`, `visibility`, `currentVersion`, `isDirty`, `bestPractice`, `createdById`, `created`, `modifiedById`, `modified`) (SELECT '#{tmplt.title.strip}', '#{org.ror_id}', '#{tmplt.visibility == 1 ? "PUBLIC" : "PRIVATE"}', 'v#{tmplt.version + 1}', 0, #{tmplt.is_default ? 1 : 0}, `users`.`id`, '#{tmplt.created_at}', `users`.`id`, '#{tmplt.updated_at}' FROM `users` WHERE `affiliationId` = '#{org.ror_id}' AND `role` = 'ADMIN');"
      p "INSERT INTO `versionedTemplates` (`templateId`, `active`, `version`, `versionType`, `versionedById`, `comment`, `name`, `ownerId`, `visibility`, `bestPractice`, `created`, `modified`, `createdById`, `modifiedById`) (SELECT `templates`.`id`, 1, `templates`.`currentVersion`, 'PUBLISHED', `templates`.`createdById`, '', `templates`.`name`, `templates`.`ownerId`, `templates`.`comment`, `templates`.`visibility`, `templates`.`bestPractice`, `templates`.`created`, `templates`.`modified`, `templates`.`createdbyId`, `templates`.`modifiedById` FROM `templates` WHERE `templates`.`name` = '#{tmplt.title.strip}' AND `templates`.`ownerId` = '#{org.ror_id}' LIMIT 1);"
      p '---'
    end
  end

  desc 'Generate all of the section migrations'
  task generate_sections: :environment do

  end
end