class CutScene < ActiveRecord::Base
  belongs_to :chapter
  belongs_to :battle_level
  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

  has_attached_file :end_cutscene, :styles => { :cool => "960x600>", :thumb => "100x100>"}
  validates_attachment_content_type :end_cutscene, :content_type => /\Aimage\/.*\Z/

end