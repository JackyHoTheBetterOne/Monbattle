module Codey
  extend ActiveSupport::Concern

  included do
    before_create :add_code
  end

  def add_code()
    self["code"] = SecureRandom.uuid
  end
end