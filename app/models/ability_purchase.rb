require 'aasm'

class AbilityPurchase < ActiveRecord::Base
  extend FriendlyId
  friendly_id :id_code
  belongs_to :ability
  belongs_to :user
  belongs_to :monster_unlock
  belongs_to :learner, class_name: "MonsterUnlock"

  validates :user_id, presence: {message: 'Must be entered'}
  validates :ability_id, presence: {message: 'Must be entered'}
  after_create :set_socket
  before_create :generate_code

  def self.on_monster_unlock(params = {})
    @user_id           = params[:user_id]
    @abil_id           = params[:abil_id]
    @monster_unlock_id = params[:monster_unlock_id]
    create(user_id: @user_id, ability_id: @abil_id, 
           monster_unlock_id: @monster_unlock_id, learner_id: @monster_unlock_id)
  end

  scope :number_of_ability_owned, -> (user, ability) {
    where(ability_id: ability, user_id: user)
  }

  scope :owned, -> (ability) {
    where(ability_id: ability)
  }

  scope :not_equipped, -> (ability) {
    where(ability_id: ability)
  }

  # scope :not_equipped, -> (ability) {
  #   where(monster_unlock_id: 0, ability_id: ability)
  # }
 
  scope :not_learned, -> (user_id) {
    where(learner_id: nil, user_id: user_id)
  }

  scope :search, -> (keyword) {
    if keyword.present?
      joins(:ability).where("abilities.keywords LIKE ?", "%#{keyword.downcase}%")
    end
  }

  def available(monster_unlock, ability)
    ability_owned(ability).not_equipped(monster_unlock).count
  end

  def self.abils_purchased(user)
    self.where(user_id: user)
  end

  def self.unlock_check(user, ability_id)
    where(user_id: user, ability_id: ability_id)
  end

  def portrait 
    self.ability.portrait.url(:thumb)
  end

  private

  def generate_code
    self.id_code = SecureRandom.uuid
  end

  def set_socket
    @socket = self.ability.socket
    self.socket_num = @socket
    self.save
  end

end
