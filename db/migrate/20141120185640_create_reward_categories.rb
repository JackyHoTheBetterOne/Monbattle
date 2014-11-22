class CreateRewardCategories < ActiveRecord::Migration
  def change
    create_table :reward_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
