class MonsterSkin < ActiveRecord::Base

  belongs_to :rarity

  has_many :monster_skin_equippings, dependent: :destroy
  has_many :skin_equipped_users, through: :monster_skin_equippings, source: :user
  has_many :skin_equipped_monsters, through: :monster_skin_equippings, source: :monster

  has_many :monster_skin_purchases, dependent: :destroy
  has_many :skin_purchased_users, through: :monster_skin_purchases, source: :user
  has_many :skin_restrictions, dependent: :destroy
  has_many :jobs, through: :skin_restrictions

  has_attached_file :portrait,
                    styles: { small: "150 x 150>",
                              thumb: "100 x 100>"}

  validates_attachment_content_type :portrait, :content_type => /\Aimage\/.*\Z/
  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :rarity, presence: {message: 'Must be entered'}

  before_destroy :check_for_default

  scope :find_default_skins_available, -> (job_id) {
    @job_restricted_monster_skin_ids  = find_monster_skin_ids_through_skin_restriction(job_id)
    where(id: @job_restricted_monster_skin_ids)
  }

  scope :search_by_designer, -> (name) {
    where(painter: name)
  }


  def self.find_monster_skin_ids_through_skin_restriction(job_id)
    SkinRestriction.find_monster_skins_avail_for_job_id(job_id)
  end

  private

  def check_for_default
    if self.name == "Sack"
      false
    end
  end

end
