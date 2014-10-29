class AbilityEquipping < ActiveRecord::Base
  belongs_to :ability
  belongs_to :monster_unlock

  validates :ability_id, presence: {message: 'Must be entered'},
                         uniqueness: {scope: :monster_unlock_id}

  validates :monster_unlock, presence: {message: 'Must be entered'}

  # after_create
  # after_update

  def find_user_id(monster_unlock)
    User.find(monster_unlock.user_id).id
  end


  private

  def update_ability_purchases
    @monster_unlock = self.monster_unlock
    @user_id        = find_user_id(@monster_unlock)
    @ability_id     = self.ability_id

  end

  def create_ability_purchases
  end

#### Default Ability for sockets Logic ############
  # def self.default_abil_id_for_socket(socket_num)
  #   Ability.default_id_for_socket(socket_num)
  # end

  # def self.equip_abil_for_each_socket
  #     @socket_nums.each do |socket_num|
  #       @ability_id = self.default_abil_for_socket(socket_num)

  #       self.create_default_ability_equipping_record
  #     end
  # end

  # def self.create_default_ability_equipping_record
  #   @ability_equipping                   = self.new
  #   @ability_equipping.ability_id        = @ability_id
  #   @ability_equipping.monster_unlock_id = @monster_unlock_id
  #   @ability_equipping.save
  # end

  # def self.default_equip(args = {})
  #   @socket_nums       = args[:socket_nums]
  #   @monster_unlock_id = args[:monster_unlock_id]

  #   self.equip_abil_for_each_socket
  # end
################################################

  def self.record_find(monster_unlock, ability)
    find_by(monster_unlock_id: monster_unlock, ability_id: ability)
  end

end
