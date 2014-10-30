class AddStageToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :stage, :string
  end
end
