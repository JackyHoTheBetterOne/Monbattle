class RemoveMaxApFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :max_ap, :string
  end
end
