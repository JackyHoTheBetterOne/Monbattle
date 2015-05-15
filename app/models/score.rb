class Score < ActiveRecord::Base
  include Codey
  belongs_to :scorapable, polymorphic: true
  belongs_to :area

  scope :guild_scores, -> (area_name) {
    joins(:area).where("scorapable_type = 'Guild' AND areas.name = '#{area_name}'").
      order("points DESC")
  }

  scope :individual_scores, -> (area_name) {
    joins(:area).where("scorapable_type = 'Summoner' AND areas.name = '#{area_name}'").
      order("points DESC")
  }

  scope :search_summoner_level_score, -> (id_object) {
    area_id = id_object[:area_id]
    summoner_id = id_object[:summoner_id]
    where("scorapable_type = 'Summoner' AND area_id = #{area_id} AND scorapable_id = #{summoner_id}")
  }

  scope :search_guild_level_score, -> (id_object) {
    area_id = id_object[:area_id]
    guild_id = id_object[:guild_id]
    where("scorapable_type = 'Guild' AND area_id = #{area_id} AND scorapable_id = #{guild_id}")
  }

  # scope :friend_scores, -> (*names) {
  #   includes(:scorapable).where("scorapable_type = 'Summoner'").where(scorapable: {name: names})
  # }

  def self.friend_scores(names, area_id)
    Summoner.friends(names).map(&:scores).flatten.select{|s|s.area_id == area_id}
  end

end