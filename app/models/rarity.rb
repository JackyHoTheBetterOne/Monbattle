class Rarity < ActiveRecord::Base
  has_many :monsters
  has_many :abilities
  has_many :monster_skins

  validates :name, presence: {message: 'Must be entered'}

  def self.worth(rarity)
    where(name: rarity)
  end

end
