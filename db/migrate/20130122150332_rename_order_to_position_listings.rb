class RenameOrderToPositionListings < ActiveRecord::Migration
  def up
    remove_column :listings, :order
    add_column :listings, :position, :integer, :null => false, :default => 1
  end

  def down
    remove_column :listings, :position
    add_column :listings, :order, :integer
  end
end
