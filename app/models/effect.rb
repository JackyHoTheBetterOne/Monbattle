class Effect < ActiveRecord::Base

  has_many :ability_effects
  has_many :abilities, through: :ability_effects
  has_many :ability_purchases
  has_many :ability_purchased_users, through: :ability_purchases, source: :user
  has_many :ability_equippings
  has_many :ability_equipped_monsters, through: :ability_equippings, source: :monster

end
