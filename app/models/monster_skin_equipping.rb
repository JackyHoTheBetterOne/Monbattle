class MonsterSkinEquipping < ActiveRecord::Base
  belongs_to :monster
  belongs_to :monster_skin
  belongs_to :user

  validates :monster_id, presence: {message: 'Must be entered'},
                                    uniqueness: {scope: :user_id}
  validates :monster_skin_id, presence: {message: 'Must be entered'}
  validates :user_id, presence: {message: 'Must be entered'}
end