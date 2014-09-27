class RemoveSlotFromAbilities < ActiveRecord::Migration
  def change
    remove_column :abilities, :slot, :integer
  end
end
