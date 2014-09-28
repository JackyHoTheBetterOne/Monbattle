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

end
