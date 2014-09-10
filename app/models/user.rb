class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :battles
  has_many :parties

  has_many :monster_unlocks, dependent: :destroy
  has_many :unlocked_monsters, through: :monster_unlocks, source: :monster
  has_many :ability_purchases, dependent: :destroy  
  has_many :purchased_abilities, through: :ability_purchases, source: :ability

  has_many :ability_equippings, dependent: :destroy
  has_many :user_equipped_abilities, through: :ability_equippings, source: :ability
  has_many :user_equipped_monsters, through: :ability_equippings, source: :monster

  has_many :monster_skin_purchases, dependent: :destroy
  has_many :monster_skins, through: :monster_skin_purchases

  # validates :user_name, presence: {message: 'Must be entered'}, uniqueness: true
  # validates :email, presence: {message: 'Must be entered'}
  # validates :password, presence: {message: 'Must be entered'}
end
