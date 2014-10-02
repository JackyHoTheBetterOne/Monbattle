class RemovePowerLevelFromAbilities < ActiveRecord::Migration
  def change
    remove_column :abilities, :power_level, :string
  end
end
