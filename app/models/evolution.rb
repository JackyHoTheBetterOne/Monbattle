class Evolution < ActiveRecord::Base
  belongs_to :evolved_state
  belongs_to :monster

end
