class MonsterUnlock < ActiveRecord::Base
  belongs_to :user
  belongs_to :monster

  has_many :ability_equippings, dependent: :destroy
  has_many :abilities, through: :ability_equippings
  has_many :members, dependent: :destroy
  has_many :parties, through: :members

  validates :monster_id, presence: {message: 'Must be entered'},
                                    uniqueness: {scope: :user_id}
  validates :user_id, presence: {message: 'Must be entered'}

  scope :lvl1_evolves, -> { joins(:job).where('job')}

  def name
    self.monster.name
  end

  def max_hp
    self.monster.max_hp
  end

  def hp
    self.monster.max_hp
  end

  def cost(index)
    self.abilities[index].ap_cost
  end

  def target(index)
    self.abilities[index].targeta
  end

  def image(user)
    self.monster.image(user)
  end

  def abdex(ability)
    self.monster.abilities.index(ability)
  end

  def evolved_json

    def unlocked_monsters_ids
      MonsterUnlock.where(user_id: self.user_id).pluck(:monster_id)
    end

    def linked_evolution_ids
      self.monster.evolutions.where(id: unlocked_monsters_ids).pluck(:id)
    end

    def unlocked_evolves
      MonsterUnlock.where(user_id: self.user_id, monster_id: linked_evolution_ids)
    end

    json_array = []

    unlocked_evolves.each do |unlocked_evo|
      evolve_hash = { name:   unlocked_evo.monster.name,
                      max_hp: unlocked_evo.monster.max_hp,
                      hp:     unlocked_evo.monster.max_hp,
                      summon: unlocked_evo.monster.summon_cost
                      abilities: []
                        unlocked_evo.monsters.abilities.each do |ability|
                          { name: ability.name,
                            ap_cost: ability.ap_cost,
                            stat_change: ability.stat_change
                          }



                        end
      json_array.push(evolve_hash)
    end

    return json_array

  end

  # def linked_evolutions
  #   self.monster.evolutions.where(id: MonsterUnlock.where(user_id: self.user_id).pluck(:monster_id))
  # end

end
