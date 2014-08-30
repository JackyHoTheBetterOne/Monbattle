class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :battles
  has_many :monsters
  has_many :ability_purchases  
  has_many :purchased_abilities, through: :ability_purchases, source: :ability
  has_many :monster_skin_purchases
  has_many :purchased_monster_skins, through: :monster_skin_purchases, source: :monster_skin

end
