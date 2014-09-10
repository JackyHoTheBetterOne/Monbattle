class MonsterSkinEquipping < ActiveRecord::Base
  belongs_to :monster
  belongs_to :monster_skin
end
