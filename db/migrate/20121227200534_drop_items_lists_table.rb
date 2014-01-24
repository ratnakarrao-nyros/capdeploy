class DropItemsListsTable < ActiveRecord::Migration
  def self.up
    drop_table :items_lists
  end

  def self.down # see 20121211003831_items_lists.rb
    create_table :items_lists, :id => false do |t|
      t.integer :item_id
      t.integer :list_id
    end
  end
end
