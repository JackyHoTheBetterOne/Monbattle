class MonsterUnlock < ActiveRecord::Base
  belongs_to :user
  belongs_to :monster

  validates :monster_id, presence: {message: 'Must be entered'}
  validates :user_id, presence: {message: 'Must be entered'}
end
