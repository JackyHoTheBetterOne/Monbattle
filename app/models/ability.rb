class Ability < ActiveRecord::Base

  has_many :ability_effects
  has_many :effects, through: :ability_effects
end
