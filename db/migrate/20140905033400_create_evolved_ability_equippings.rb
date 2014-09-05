class CreateEvolvedAbilityEquippings < ActiveRecord::Migration
  def change
    create_table :evolved_ability_equippings do |t|
      t.references :evolved_state, index: true
      t.references :abilities, index: true

      t.timestamps
    end
  end
end
