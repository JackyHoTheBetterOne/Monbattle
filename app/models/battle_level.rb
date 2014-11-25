class BattleLevel < ActiveRecord::Base
  has_many :battles
  
  validates :name, presence: {message: 'Must be entered'}, uniqueness: :true

  has_attached_file :background, :styles => { :cool => "960x600>", :thumb => "100x100>" }
  validates_attachment_content_type :background, :content_type => /\Aimage\/.*\Z/

  has_many :cut_scenes
  has_many :monster_assignments
  has_many :monsters, through: :monster_assignments

  after_destroy :delete_party

  def start_cut_scenes
    array = []
    self.cut_scenes.where("cut_scenes.to_start is true").order("cut_scenes.order ASC").each do |c|
      array << c.image.url(:cool)
    end
    return array
  end

  def end_cut_scenes
    array = []
    self.cut_scenes.where("cut_scenes.to_start is false").order("cut_scenes.order ASC").each do |c|
      array << c.image.url(:cool)
    end
    return array
  end

  private
  def delete_party
    Party.where("user_id = 2").where(name: self.name).destroy_all
  end

end
