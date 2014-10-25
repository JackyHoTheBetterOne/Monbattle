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

  def self.default_skin_id
    @default_skin_name = "Sack"
    self.where(name: @default_skin_name).first.id
  end
end
