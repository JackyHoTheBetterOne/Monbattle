class AddNpcToParties < ActiveRecord::Migration
  def change
    add_column :parties, :npc, :boolean, default: false
  end
end
