class Notification < ActiveRecord::Base
  belongs_to :notificapable, polymorphic: true
  before_create :add_code


  scope :search_summoner_notification_request, -> (summoner_name) {
    where("title = 'Guild Request' AND sent_by = '#{summoner_name}'")
  }

  private
  def add_code
    self.code = SecureRandom.uuid
  end
end
