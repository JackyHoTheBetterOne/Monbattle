class Fights < ActiveRecord::Base
  belongs_to :user
  belongs_to :battle
end
