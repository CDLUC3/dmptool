class AddFunderAndOrgAndGrantToPlans < ActiveRecord::Migration
  def change
    add_reference :plans, :org, foreign_key: true
    add_column :plans, :funder_id, :integer, index: true
    add_column :plans, :grant_id, :integer, index: true
  end
end
