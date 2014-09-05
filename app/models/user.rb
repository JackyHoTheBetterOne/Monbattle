class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :battles
  has_many :monsters
  has_many :ability_purchases, dependent: :destroy  
  has_many :abilities, through: :ability_purchases
  has_many :monster_skin_purchases, dependent: :destroy
  has_many :monster_skins, through: :monster_skin_purchases

end
