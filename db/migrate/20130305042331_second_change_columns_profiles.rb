class SecondChangeColumnsProfiles < ActiveRecord::Migration
  def up
    remove_column :profiles, :sex
    remove_column :profiles, :state
    add_column :profiles, :sex, :boolean
    add_column :profiles, :state, :string
  end

  def down
    remove_column :profiles, :sex
    remove_column :profiles, :state
    add_column :profiles, :sex, :string
    add_column :profiles, :state, :integer, :null => false, :default => 1
  end
end
