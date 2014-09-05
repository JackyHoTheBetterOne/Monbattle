class RemoveExpFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :exp, :string
  end
end
