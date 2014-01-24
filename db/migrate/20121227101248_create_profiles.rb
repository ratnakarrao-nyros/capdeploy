class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.datetime :birthday
      t.string :sex
      t.text :address
      t.string :city
      t.string :zip
      t.string :website

      t.timestamps
    end
  end
end
