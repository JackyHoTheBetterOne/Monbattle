class QuestType < ActiveRecord::Base
  has_many :quests

  validates :name, presence: {message: 'Must be entered'}

end