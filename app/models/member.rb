class Member < ActiveRecord::Base
  belongs_to :monster_unlock
  belongs_to :party

  validates :monster_unlock, uniqueness: {scope: :party_id}
  validates :party_id, presence: {message: 'Must be entered'}
  # validates :no_evolutions_on_party, {message: 'Can not add an Evolved State to the party!'}
  # validates :party_members_count_valid, {message: 'You already have 4 members!'}

 # private

 #  def party_members_count_valid
 #    self.party.members.count <= 4
 #  end

 #  def no_evolutions_on_party
 #    if self.monster_unlock.monster.evolved_from.blank? == true
 #    else
 #      false
 #    end
 #  end

end
