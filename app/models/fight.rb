class Fight < ActiveRecord::Base
  belongs_to :party
  belongs_to :battle
end
