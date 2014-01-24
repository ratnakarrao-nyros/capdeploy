class ChangeColumnsProfiles < ActiveRecord::Migration
  def up
    remove_column :profiles, :phone
    remove_column :profiles, :address
    remove_column :profiles, :zip
    add_column :profiles, :state, :integer, :null => false, :default => 1
  end

  def down
    add_column :profiles, :phone, :string
    add_column :profiles, :address, :text
    add_column :profiles, :zip, :string
    remove_column :profiles, :state
  end
end
