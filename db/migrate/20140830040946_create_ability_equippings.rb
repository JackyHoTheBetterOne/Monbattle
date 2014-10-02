class CreateAbilityEquippings < ActiveRecord::Migration
  def change
    create_table :ability_equippings do |t|
      t.references :ability, index: true
      t.references :monster, index: true

      t.timestamps
    end
  end
end
