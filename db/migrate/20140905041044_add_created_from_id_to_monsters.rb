class AddCreatedFromIdToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :created_from_id, :integer
  end
end
