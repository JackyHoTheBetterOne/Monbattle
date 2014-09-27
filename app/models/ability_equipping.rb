class AbilityEquipping < ActiveRecord::Base
  belongs_to :ability
  belongs_to :monster_unlock

  validates :ability_id, presence: {message: 'Must be entered'},
                         uniqueness: {scope: :monster_unlock_id}

  validates :monster_unlock, presence: {message: 'Must be entered'}

  #Create a check to validate only one equipped ability for socket 1
  # def socket_check
  #   if self.where(ability_id: )
  # end



end
