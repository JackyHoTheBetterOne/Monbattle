class MonsterSkin < ActiveRecord::Base

  belongs_to :job

  has_many :monster_skin_equippings, dependent: :destroy
  has_many :monsters, through: :monster_skin_equippings
  has_many :monster_skin_purchases, dependent: :destroy
  has_many :users, through: :monster_skin_purchases
  
end
