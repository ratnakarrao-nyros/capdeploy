class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :category

      t.timestamps
    end
  end
end
