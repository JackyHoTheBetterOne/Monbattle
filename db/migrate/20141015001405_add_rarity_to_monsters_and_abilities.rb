class AddRarityToMonstersAndAbilities < ActiveRecord::Migration
  def change
    add_reference :abilities, :rarity, index: true
    add_reference :monsters, :rarity, index: true
  end
end
