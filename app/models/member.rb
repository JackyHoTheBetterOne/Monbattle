class Member < ActiveRecord::Base
  belongs_to :monster_unlock
  belongs_to :party

  validates :monster_unlock, uniqueness: {scope: :party_id}
  validates :party_id, presence: {message: 'Must be entered'}

 private

  def party_members_count_valid
    (user).parties.members.count <= 4
  end

end
