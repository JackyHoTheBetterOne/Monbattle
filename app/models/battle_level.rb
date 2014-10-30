class BattleLevel < ActiveRecord::Base
  has_many :battles

  validates :name, presence: {message: 'Must be entered'}, uniqueness: :true

  has_attached_file :background, :styles => { :large => "960x500>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :background, :content_type => /\Aimage\/.*\Z/

  has_many :monster_assignments
  has_many :monsters, through: :monster_assignments

end
