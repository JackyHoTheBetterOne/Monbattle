class AbilityPurchase < ActiveRecord::Base
  belongs_to :ability
  belongs_to :user
  belongs_to :monster_unlock

  validates :user_id, presence: {message: 'Must be entered'}
  validates :ability_id, presence: {message: 'Must be entered'}
  after_create :set_socket

  def self.on_monster_unlock(params = {})
    @user_id           = params[:user_id]
    @abil_id           = params[:abil_id]
    @monster_unlock_id = params[:monster_unlock_id]
    create(user_id: @user_id, ability_id: @abil_id, monster_unlock_id: @monster_unlock_id)
  end

  scope :number_of_ability_owned, -> (user, ability) {
    where(ability_id: ability, user_id: user)
  }

  scope :owned, -> (ability) {
    where(ability_id: ability)
  }

  scope :not_equipped, -> (ability) {
    where(monster_unlock_id: 0, ability_id: ability)
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

  private

  def set_socket
    @socket = self.ability.socket
    self.socket_num = @socket
    self.save
  end

end
