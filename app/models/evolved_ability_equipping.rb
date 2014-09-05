class EvolvedAbilityEquipping < ActiveRecord::Base
  belongs_to :evolved_state
  belongs_to :abilities
end
