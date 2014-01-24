class RemoveIsObjectiveFromLists < ActiveRecord::Migration
  def up
    remove_column :lists, :is_objective
  end

  def down
    add_column :lists, :is_objective, :boolean, :default => false
  end
end
