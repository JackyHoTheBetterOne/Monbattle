class EnemyMember < ActiveRecord::Base
  belongs_to :monster_id
  belongs_to :enemy_party
end
