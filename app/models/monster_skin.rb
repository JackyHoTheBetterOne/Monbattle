class MonsterSkin < ActiveRecord::Base

  has_attached_file :avatar,
                    styles: { medium: "300 x 300",
                              small: "200 x 200",
                              thumb: "100 x 100",
                              tiny: "50 x 50>"}

  has_many :monster_skin_equippings, dependent: :destroy
  has_many :skin_equipped_users, through: :monster_skin_equippings, source: :user
  has_many :skin_equipped_monsters, through: :monster_skin_equippings, source: :monster

  has_many :monster_skin_purchases, dependent: :destroy
  has_many :skin_purchased_users, through: :monster_skin_purchases, source: :user
  has_many :skin_restrictions, dependent: :destroy
  has_many :jobs, through: :skin_restrictions

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

end
