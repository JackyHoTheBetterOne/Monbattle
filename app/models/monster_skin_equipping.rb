class MonsterSkinEquipping < ActiveRecord::Base
  belongs_to :monster
  belongs_to :monster_skin
  belongs_to :user

  validates :monster_id, presence: {message: 'Must be entered'},
                                    uniqueness: {scope: :user_id}
  validates :monster_skin_id, presence: {message: 'Must be entered'}
  validates :user_id, presence: {message: 'Must be entered'}

  # def self.find_default_skin_id
  #   MonsterSkin.default_skin_id
  # end

  # def self.create_default_monster_skin_equipping_record
  #   @monster_skin_equipping = self.new
  #   @monster_skin_equipping.user_id =  @user_id
  #   @monster_skin_equipping.monster_id = @monster_id
  #   @monster_skin_equipping.monster_skin_id = @monster_skin_id
  #   @monster_skin_equipping.save
  # end

  # def self.default_equip(args = {})
  #   @monster_skin_id = self.find_default_skin_id
  #   @user_id         = args[:user_id]
  #   @monster_id      = args[:monster_id]

  #   self.create_default_monster_skin_equipping_record
  # end

end