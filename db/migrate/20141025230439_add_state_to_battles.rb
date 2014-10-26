class AddStateToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :aasm_state, :string
  end
end
