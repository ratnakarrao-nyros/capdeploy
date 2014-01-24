class AddCategoryIdToLists < ActiveRecord::Migration
  # replace category:string with category_id:integer
  def self.up
    remove_column :lists, :category
    add_column :lists, :category_id, :integer
  end

  def self.down
    remove_column :lists, :category_id
    add_column :lists, :category, :string
  end
end
