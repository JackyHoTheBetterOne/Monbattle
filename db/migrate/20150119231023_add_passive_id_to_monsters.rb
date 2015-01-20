class AddPassiveIdToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :passive_id, :integer
  end
end
