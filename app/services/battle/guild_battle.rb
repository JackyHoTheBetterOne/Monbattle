class Battle::GuildBattle
  include Virtus.model
  attribute :battle, Battle

  def call
    @battle_level = battle.battle_level
    @area = @battle_level.area
    @summoner = User.find_by_user_name(battle.victor).summoner
    @guild = @summoner.guild
    id_object = {area_id: @area.id, summoner_id: @summoner.id}
    @summoner_score = Score.search_summoner_level_score(id_object)[0]
    id_object = {area_id: @area.id, guild_id: @guild.id}
    @guild_score = Score.search_guild_level_score(id_object)[0]
    if battle.victor != "NPC"
      base_index = @battle_level.gbattle_weight_base
      turn_index = @battle_level.gbattle_weight_turn
      time_index = @battle_level.gbattle_weight_time
      score = base_index + base_index * (turn_index/battle.round_taken) + base_index * (time_index/battle.time_taken)
      
      score = score.round
      if @summoner_score == nil
        Score.create!(points: score, area_id: @area.id,
                      scorapable_type: 'Summoner', scorapable_id: @summoner.id)
      else
        @summoner_score.points += score
        @summoner_score.num_of_battles += 1
        @summoner_score.save
      end

      if @guild_score == nil
        Score.create!(points: score, area_id: @area.id,
                      scorapable_type: 'Guild', scorapable_id: @guild.id)
      else
        @guild_score.points += score
        @guild_score.num_of_battles += 1
        @guild_score.save
      end
    end
  end
end