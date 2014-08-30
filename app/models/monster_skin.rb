class MonsterSkin < ActiveRecord::Base

  has_many :monsters
  has_many :monster_skin_purchases
  has_many :monster_skin_purchased_users, through: :monster_skin_purchases, source: :user
  
end
