class CreateAbilityEffects < ActiveRecord::Migration
  def change
    create_table :ability_effects do |t|
      t.references :ability, index: true
      t.references :effect, index: true

      t.timestamps
    end
  end
end
