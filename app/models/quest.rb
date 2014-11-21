class Quest < ActiveRecord::Base
  belongs_to :quest_type
  belongs_to :reward_category

  validates :name, presence: {message: 'Must be entered'}


  def type
    self.quest_type.name
  end

  def reward
    self.reward_category.name
  end

end
