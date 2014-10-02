class AbilityRestriction < ActiveRecord::Base
  belongs_to :job
  belongs_to :ability
end
