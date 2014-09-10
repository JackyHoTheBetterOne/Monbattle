class Members < ActiveRecord::Base
  belongs_to :monster
  belongs_to :party

 private

  def party_members_count_valid(user)
    (user).parties.members.count <= 4
  end

end
