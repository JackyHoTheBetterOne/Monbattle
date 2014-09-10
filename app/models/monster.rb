class Monster < ActiveRecord::Base

  belongs_to :job
  belongs_to :element

  has_many :evolutions, class_name: "Monster",
                        foreign_key: "evolved_from_id"
  belongs_to :evolved_from, class_name: "Monster"

  has_many :ability_equippings, dependent: :destroy
  has_many :monster_equipped_abilities, through: :ability_equippings, source: :ability
  has_many :monster_equipped_users, through: :ability_equippings, source: :user

  has_many :monster_skin_equippings, dependent: :destroy
  has_many :monster_skins, through: :monster_skin_equippings
  has_many :monster_unlocks, dependent: :destroy
  has_many :monster_unlocked_users, through: :monster_unlocks, source: :user
  has_many :members, dependent: :destroy
  has_many :parties, through: :members

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :max_hp, presence: {message: 'Must be entered'}
  validates :element_id, presence: {message: 'Must be entered'}
  validates :job_id, presence: {message: 'Must be entered'}, uniqueness: true
  validates :dmg_modifier, presence: {message: 'Must be entered'}
  validates :hp_modifier, presence: {message: 'Must be entered'}
  validates :description, presence: {message: 'Must be entered'}
  validates :evolved_from_id, presence: {message: 'Must be entered'}


  def party_member_id(user)
    members.find_by_party_id(user.parties.first.id)
  end

  def monster_templates
    Monster.where(is_template: true).empty?
  end

  def ability_equipping_for(current_user)
    ability_equippings.where(user: current_user).first
  end

  def not_evolved_monster_check(monster_id)
    Monster.find(monster_id).evolved_from.blank?
  end

end
