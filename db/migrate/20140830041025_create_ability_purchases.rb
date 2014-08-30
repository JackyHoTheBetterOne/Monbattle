class CreateAbilityPurchases < ActiveRecord::Migration
  def change
    create_table :ability_purchases do |t|
      t.references :ability, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
