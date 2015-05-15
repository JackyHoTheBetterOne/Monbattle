class UserAvatar < ActiveRecord::Base
  belongs_to :avatar
  belongs_to :summoner
end
