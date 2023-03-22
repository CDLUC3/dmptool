# frozen_string_literal: true

# Upgrade tasks for 4.x versions. See https://github.com/DMPRoadmap/roadmap/releases for information
# on how and when to run each task.

# rubocop:disable Naming/VariableNumber
namespace :v4 do
  desc 'Upgrade from v4.0.8 to v4.0.9'
  task upgrade_4_0_9: :environment do
    puts 'Converting the old research_outputs.output_type Integer field (an enum in the model) to a string '
    puts 'value in the new research_outputs.research_output_type field'

    ResearchOutput.all.each { |rec| rec.update(research_output_type: rec.output_type.to_s) }

    puts 'DONE'
  end
end
