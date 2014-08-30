class AbilityEffect < ActiveRecord::Base
  belongs_to :ability
  belongs_to :effect
end
