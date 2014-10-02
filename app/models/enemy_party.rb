class EnemyParty < ActiveRecord::Base
  belongs_to :battle_level

  has_many :enemy_members, dependent: :destroy
  has_many :monsters, through: :enemy_members
end
