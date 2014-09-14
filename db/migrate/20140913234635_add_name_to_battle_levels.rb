class AddNameToBattleLevels < ActiveRecord::Migration
  def change
    add_column :battle_levels, :name, :string
  end
end
