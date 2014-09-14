class MonsterSkinPurchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :monster_skin

  validates :user_id, presence: {message: 'Must be entered'}
  validates :monster_skin_id, presence: {message: 'Must be entered'}

end
