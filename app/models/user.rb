class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  has_one :summoner, dependent: :destroy
  has_many :parties, dependent: :destroy
  has_many :members, through: :parties

  serialize :raw_oauth_info

  has_many :monster_skin_equippings, dependent: :destroy
  has_many :user_skin_equipped_monsters, through: :monster_skin_equippings, source: :monster
  has_many :user_skin_equipped_skins, through: :monster_skin_equippings, source: :monster_skin

  has_many :monster_unlocks, dependent: :destroy
  has_many :unlocked_monsters, through: :monster_unlocks, source: :monster
  has_many :ability_equippings, through: :monster_unlocks

  has_many :monster_skin_purchases, dependent: :destroy
  has_many :user_monster_skins, through: :monster_skin_purchases, source: :monster_skin
  has_many :ability_purchases, dependent: :destroy
  has_many :purchased_abilities, through: :ability_purchases, source: :ability

  validates :user_name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :email, presence: {message: 'Must be entered'}
  # validates :password, presence: {message: 'Must be entered'}

  after_create :create_summoner
  after_create :create_party
  after_create :create_default_members

  def can_add_to_party?(mon_unlock)
    if self.members.count == 0 || self.members.count < 4 && self.members.where(monster_unlock_id: mon_unlock).empty?
      return true
    else
      return false
    end
  end

  def can_remove_from_party?(mon_unlock)
    if self.members.count >= 1 && self.members.where(monster_unlock_id: mon_unlock).exists?
      return true
    else
      return false
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create!(user_name: auth.extra.raw_info.name,
                            provider: auth.provider,
                            uid: auth.uid,
                            email: auth.info.email,
                            password: Devise.friendly_token[0,20],
                            raw_oauth_info: auth
                           )
      end
    end
  end

  private

  def create_summoner
    @summoner = Summoner.new
    @summoner.user_id = self.id
    @summoner.name = self.user_name
    @summoner.save
  end

  def create_party
    @party = Party.new
    @party.name = "Your Party"
    @party.user_id = self.id
  end

  def


end
