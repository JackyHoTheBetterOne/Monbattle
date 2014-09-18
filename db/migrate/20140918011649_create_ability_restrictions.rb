class CreateAbilityRestrictions < ActiveRecord::Migration
  def change
    create_table :ability_restrictions do |t|
      t.references :job, index: true
      t.references :ability, index: true

      t.timestamps
    end
  end
end
