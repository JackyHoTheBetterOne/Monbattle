class Effect < ActiveRecord::Base
  
  belongs_to :element_template
  has_many :ability_effects, dependent: :destroy
  has_many :abilities, through: :ability_effects
  has_many :ability_purchases
  has_many :ability_purchased_users, through: :ability_purchases, source: :user
  has_many :ability_equippings
  has_many :ability_equipped_monsters, through: :ability_equippings, source: :monster

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :damage, presence: {message: 'Must be entered'}
  validates :target, presence: {message: 'Must be entered'}

end
