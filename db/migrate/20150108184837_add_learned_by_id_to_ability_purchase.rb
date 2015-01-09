class AddLearnedByIdToAbilityPurchase < ActiveRecord::Migration
  def change
    add_column :ability_purchases, :learner_id, :integer
  end
end
