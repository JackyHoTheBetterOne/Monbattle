class UnlockCode < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true
  validates :category, presence: true
end
