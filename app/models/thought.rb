class Thought < ActiveRecord::Base
  belongs_to :personality

  validates :comment, presence: {message: 'Must be entered'},
                              uniqueness: {scope: :personality}
end
