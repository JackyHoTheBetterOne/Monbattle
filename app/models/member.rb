class Member < ActiveRecord::Base
  belongs_to :monster
  belongs_to :party

  validates :monster_id, uniqueness: {scope: :party_id}

end
