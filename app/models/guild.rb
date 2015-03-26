class Guild < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :leader_id, presence: true

  belongs_to :leader, class_name: "Summoner", foreign_key: "led_guild_id"
  has_many :members, class_name: "Summoner", foreign_key: "guild_id"
  has_many :sub_leaders, class_name: "Summoner", foreign_key: "sub_led_guild_id"
  has_many :guild_messages

end
