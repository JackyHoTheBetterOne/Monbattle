class AddTimeRequirementToBattleLevels < ActiveRecord::Migration
  def change
    add_column :battle_levels, :time_requirement, :integer
    remove_column :battles, :time_taken
    add_column :battles, :time_taken, :integer
  end
end
