class MonsterSkin < ActiveRecord::Base

  has_many :monsters
  has_many :evolved_states
  has_many :monster_skin_purchases, dependent: :destroy
  has_many :users, through: :monster_skin_purchases
  
end
