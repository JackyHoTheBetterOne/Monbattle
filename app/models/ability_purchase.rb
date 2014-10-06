class AbilityPurchase < ActiveRecord::Base
  belongs_to :ability
  belongs_to :user

  validates :ability_id, presence: {message: 'Must be entered'},
                         uniqueness: {scope: :user_id}
  validates :user_id, presence: {message: 'Must be entered'}

  def self.abils_purchased(user)
    self.where(user_id: user)
  end

end
