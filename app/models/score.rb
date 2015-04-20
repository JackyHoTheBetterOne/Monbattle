class Score < ActiveRecord::Base
  belongs_to :scorapable, polymorphic: true
  include Codey

  scope :search_summoner_level_score, -> (id_object) {
    level_id = id_object[:level_id]
    summoner_id = id_object[:summoner_id]
    where("scorapable_type = 'Summoner' AND battle_level_id = #{level_id} AND scorapable_id = #{summoner_id}")
  }

  scope :search_guild_level_score, -> (id_object) {
    level_id = id_object[:level_id]
    guild_id = id_object[:guild_id]
    where("scorapable_type = 'Guild' AND battle_level_id = #{level_id} AND scorapable_id = #{guild_id}")
  }


end
