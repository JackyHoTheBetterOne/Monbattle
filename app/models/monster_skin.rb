class MonsterSkin < ActiveRecord::Base

  belongs_to :rarity

  has_many :monster_skin_equippings, dependent: :destroy
  has_many :skin_equipped_users, through: :monster_skin_equippings, source: :user
  has_many :skin_equipped_monsters, through: :monster_skin_equippings, source: :monster

  has_many :monster_skin_purchases, dependent: :destroy
  has_many :skin_purchased_users, through: :monster_skin_purchases, source: :user
  has_many :skin_restrictions, dependent: :destroy
  has_many :jobs, through: :skin_restrictions

  has_attached_file :avatar,
                    styles: { medium: "300 x 300>",
                              small: "150x150>",
                              thumb: "100 x 100>",
                              tiny: "50 x 50>"}
  has_attached_file :portrait,
                    styles: { small: "150x150>",
                              thumb: "100 x 100>"}

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :portrait, :content_type => /\Aimage\/.*\Z/
  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :rarity, presence: {message: 'Must be entered'}

  after_create :set_former_name_field
  after_update :change_default_skin_name_for_monsters

  scope :find_default_skins_available, -> (job_id) {
    @job_restricted_monster_skin_ids  = find_monster_skin_ids_through_skin_restriction(job_id)
    where(id: @job_restricted_monster_skin_ids)
  }

  def change_default_skin_name_for_monsters
    if self.former_name == self.name
    else
      Monster.update_default_skin_name(former_name: self.former_name, new_name: self.name)
    end
  end

  def self.find_monster_skin_ids_through_skin_restriction(job_id)
    SkinRestriction.find_monster_skins_avail_for_job_id(job_id)
  end

  def self.default_skin_id(skin_name)
    where(name: skin_name).first.id
  end

  private

  def set_former_name_field
    self.former_name = self.name
    self.save
  end

end
