class Member < ActiveRecord::Base
  belongs_to :monster_unlock
  belongs_to :party

  validates :monster_unlock, uniqueness: {scope: :party_id}

  def monster_unique
    self.monster_unlock
  end

end
