class AbilityPurchase < ActiveRecord::Base
  belongs_to :ability
  belongs_to :user
  belongs_to :monster_unlock

  validates :user_id, presence: {message: 'Must be entered'}
  validates :ability_id, presence: {message: 'Must be entered'}
  # validates :socket_num, uniqueness: {scope: :monster_unlock_id}, :unless => self.user_id == 0
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

  # scope :available, -> (monster_unlock, ability) {
  #   where('monster_unlock_id not in (?) AND ability_id in (?)', monster_unlock, ability)
  # }

  def available(monster_unlock, ability)
    ability_owned(ability).not_equipped(monster_unlock).count
  end


  # scope :find_ability_purchases_for_socket, -> (socket_num) {
  #   @ability_ids = Ability.find_abilities_for_socket(socket_num)
  #   where(ability_id: @ability_ids)
  # }

  # def self.check_for_equipped_ability

  # end

  # def self.create_default_abil_purchase(user_id, abil_id)
  # end

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
