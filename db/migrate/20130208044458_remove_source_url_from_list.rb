class RemoveSourceUrlFromList < ActiveRecord::Migration
  def up
    remove_column :lists, :source_url
  end

  def down
    add_column :lists, :source_url, :string
  end
end
