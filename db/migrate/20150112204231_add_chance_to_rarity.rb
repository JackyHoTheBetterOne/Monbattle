class AddChanceToRarity < ActiveRecord::Migration
  def change
    add_column :rarities, :chance, :float
    add_column :abilities, :is_featured, :boolean
  end
end
