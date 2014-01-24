class AddColumsToList < ActiveRecord::Migration
  def up
    add_column :lists, :state, :string, :null => false, :default => "pending"
  end

  def down
    remove_column :comments, :state
  end
end
