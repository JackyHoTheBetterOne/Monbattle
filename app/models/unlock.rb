class Unlock < ActiveRecord::Base
  belongs_to :monster
  belongs_to :user
end
