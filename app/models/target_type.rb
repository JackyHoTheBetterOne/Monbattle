class TargetType < ActiveRecord::Base
  has_many :target_categories
  has_many :targets, through: :target_categories
end
