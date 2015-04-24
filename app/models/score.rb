class Score < ActiveRecord::Base
  include Codey
  belongs_to :scorapable, polymorphic: true
  belongs_to :area

  scope :guild_scores, -> (area_name) {
    joins(:area).where("scorapable_type LIKE 'Guild' AND areas.name LIKE '#{area_name}'").
      order(:points)
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


end
