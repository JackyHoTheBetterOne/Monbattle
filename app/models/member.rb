class Member < ActiveRecord::Base
  belongs_to :monster_unlock
  belongs_to :party
  belongs_to :user

  validates :monster_unlock, uniqueness: {scope: :party_id}
  validates :party_id, presence: {message: 'Must be entered'}

  def mon_portrait(user)
    self.monster_unlock.mon_portrait(user)
  end
end
