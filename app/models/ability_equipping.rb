class AbilityEquipping < ActiveRecord::Base
  belongs_to :ability
  belongs_to :monster
end
