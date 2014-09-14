class Members < ActiveRecord::Base
  belongs_to :monster
  belongs_to :party

  validates :monster_id, presence: {message: 'Must be entered'}
  validates :party_id, presence: {message: 'Must be entered'}

 private

  def party_members_count_valid(user)
    (user).parties.members.count <= 4
  end

end
