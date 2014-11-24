class AddRewardCategoryReferenceToQuests < ActiveRecord::Migration
  def change
    add_reference :quests, :reward_category, index: true
  end
end
