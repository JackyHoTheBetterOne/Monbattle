class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :fights, dependent: :destroy
  has_many :battles, through: :fights
  has_many :parties, dependent: :destroy

  has_many :monster_skin_equippings, dependent: :destroy
  has_many :user_skin_equipped_monsters, through: :monster_skin_equippings, source: :monster
  has_many :user_skin_equipped_skins, through: :monster_skin_equippings, source: :monster_skin

  has_many :ability_equippings, dependent: :destroy
  has_many :user_equipped_abilities, through: :ability_equippings, source: :ability
  has_many :user_equipped_monsters, through: :ability_equippings, source: :monster

  has_many :monster_skin_purchases, dependent: :destroy
  has_many :user_monster_skins, through: :monster_skin_purchases, source: :monster_skin
  has_many :monster_unlocks, dependent: :destroy
  has_many :unlocked_monsters, through: :monster_unlocks, source: :monster
  has_many :ability_purchases, dependent: :destroy
  has_many :purchased_abilities, through: :ability_purchases, source: :ability

  validates :user_name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :email, presence: {message: 'Must be entered'}
  validates :password, presence: {message: 'Must be entered'}

  def party_member_count(current_user_id)
    User.where(id: current_user_id).first.parties.first.members.count
  end

end
