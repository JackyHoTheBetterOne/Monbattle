class AddRewardsToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :reward_object, :hstore, default: {tiers: []}
  end
end
