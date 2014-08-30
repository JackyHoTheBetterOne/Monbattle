class AbilityPurchase < ActiveRecord::Base
  belongs_to :ability
  belongs_to :user
end
