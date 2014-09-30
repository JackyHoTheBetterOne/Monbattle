class SkinRestriction < ActiveRecord::Base
  belongs_to :job
  belongs_to :monster_skin
end
