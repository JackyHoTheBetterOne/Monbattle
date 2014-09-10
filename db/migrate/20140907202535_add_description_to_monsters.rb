class AddDescriptionToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :description, :text
  end
end
