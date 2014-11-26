class Region < ActiveRecord::Base
  has_many :areas, dependent: :destroy
  belongs_to :unlock, class_name: "Region"

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :areas, :allow_destroy => true

  has_attached_file :map, :styles => { :cool => "600x400>", :thumb => "100x100>" }
  validates_attachment_content_type :map, :content_type => /\Aimage\/.*\Z/
end
