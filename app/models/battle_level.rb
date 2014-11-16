class BattleLevel < ActiveRecord::Base
  has_many :battles

  validates :name, presence: {message: 'Must be entered'}, uniqueness: :true

  has_attached_file :background, :styles => { :cool => "960x600>", :thumb => "100x100>" }
  validates_attachment_content_type :background, :content_type => /\Aimage\/.*\Z/

  has_attached_file :start_cutscene, :styles => { :cool => "960x600>", :thumb => "100x100>"}
  validates_attachment_content_type :start_cutscene, :content_type => /\Aimage\/.*\Z/

  has_attached_file :end_cutscene, :styles => { :cool => "960x600>", :thumb => "100x100>"}
  validates_attachment_content_type :end_cutscene, :content_type => /\Aimage\/.*\Z/



  has_many :monster_assignments
  has_many :monsters, through: :monster_assignments

  after_destroy :delete_party

  private
  def delete_party
    Party.where("user_id = 2").where(name: self.name).destroy_all
  end

end
