class Monster < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :monster_template
  belongs_to :monster_skin

  has_many :ability_equippings
  has_many :equipped_abilities, through: :ability_equippings, source: :ability

end
