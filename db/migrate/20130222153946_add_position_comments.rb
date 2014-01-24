class AddPositionComments < ActiveRecord::Migration
  def up
    add_column :comments, :position, :integer, :null => false, :default => 1
  end

  def down
    remove_column :comments, :position
  end
end
