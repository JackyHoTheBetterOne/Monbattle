class MonsterSkinPurchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :monster_skin
end
