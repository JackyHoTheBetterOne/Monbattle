class GuildMessage < ActiveRecord::Base
  validates :title, presence: true, uniqueness: {scope: :guild_id}
  validates :description, presence: true
  validates :guild_id, presence: true
  validates :summoner, presence: true

  belongs_to :guild
  belongs_to :summoner
end
