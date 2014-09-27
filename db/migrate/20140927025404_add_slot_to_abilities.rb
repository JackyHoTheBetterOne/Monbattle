class AddSlotToAbilities < ActiveRecord::Migration
  def change
    add_column :abilities, :slot, :integer
  end
end
