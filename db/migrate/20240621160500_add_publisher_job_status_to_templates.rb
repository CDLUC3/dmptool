class AddPublisherJobStatusToTemplates < ActiveRecord::Migration[6.1]
  def change
    add_column :templates, :publisher_job_status, :string, default: 'success'
  end
end
