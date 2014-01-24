class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :list_id
      t.integer :item_id
      t.integer :order

      t.timestamps
    end
  end
end
