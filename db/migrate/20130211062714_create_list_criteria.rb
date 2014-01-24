class CreateListCriteria < ActiveRecord::Migration
  def change
    create_table :list_criteria do |t|
      t.string :name
      t.text :criteria

      t.timestamps
    end
  end
end
