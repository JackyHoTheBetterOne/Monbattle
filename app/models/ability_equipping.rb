class AbilityEquipping < ActiveRecord::Base
  belongs_to :ability
  belongs_to :monster
  belongs_to :user

  validates :ability_id, presence: {message: 'Must be entered'}
  validates :monster_id, presence: {message: 'Must be entered'}
  validates :user_id, presence: {message: 'Must be entered'}

end
