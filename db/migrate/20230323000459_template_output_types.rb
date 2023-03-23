class TemplateOutputTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :template_output_types do |t|
      t.belongs_to :template
      t.string "research_output_type"
    end
  end
end