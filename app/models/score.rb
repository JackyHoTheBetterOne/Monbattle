class Score < ActiveRecord::Base
  belongs_to :scorapable, polymorphic: true
  include Codey
end
