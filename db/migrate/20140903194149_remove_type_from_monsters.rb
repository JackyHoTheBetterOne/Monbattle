class RemoveTypeFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :type, :string
  end
end
