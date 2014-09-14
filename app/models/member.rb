class Member < ActiveRecord::Base
  belongs_to :monster
  belongs_to :party
end
