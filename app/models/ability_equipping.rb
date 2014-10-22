class AbilityEquipping < ActiveRecord::Base
  belongs_to :ability
  belongs_to :monster_unlock

  validates :ability_id, presence: {message: 'Must be entered'},
                         uniqueness: {scope: :monster_unlock_id}

  validates :monster_unlock, presence: {message: 'Must be entered'}

  def default_abil_socket1
    Ability.
  end

  def default_abil_socket2
    Ability.
  end


  def self.record_find(monster_unlock, ability)
    find_by(monster_unlock_id: monster_unlock, ability_id: ability)
  end



end
