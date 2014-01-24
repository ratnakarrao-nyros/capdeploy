class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.text :content
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps
    end
  end
end
