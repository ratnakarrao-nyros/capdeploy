class AddColumnsToList < ActiveRecord::Migration
  def change
    add_column :lists, :user_id, :integer
    add_column :lists, :name, :string
    add_column :lists, :description, :text
    add_column :lists, :is_objective, :boolean, :default => false
    add_column :lists, :source_url, :string
  end
end
