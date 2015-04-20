class Battle::GuildBattle
  include Virtus.model
  attribute :battle, Battle

  def call
    @battle_level = battle.battle_level
    @summoner = Summoner.find_by_name(battle.victor)
    @guild = @summoner.guild
    id_object = {level_id: @battle_level.id, summoner_id: @summoner.id}
    @summoner_score = Score.search_summoner_level_score(id_object)[0]
    id_object = {level_id: @battle_level.id, guild_id: @guild.id}
    @guild_score = Score.search_guild_level_score(id_object)[0]
    if battle.victor != "NPC"
      base_index = @battle_level.gbattle_weight_base
      turn_index = @battle_level.gbattle_weight_turn
      score = base_index + base_index * (turn_index/battle.round_taken) + base_index * (turn_index/battle.time_taken*60)
      score = Math.floor(score)
      if @summoner_score
        Score.create!(points: score, battle_level_id: @battle_level.id,
                      scorapable_type: 'Summoner', scorapable_id: @summoner.id)
      else
        @summoner_score.points += score
        @summoner_score.save
      end

      if @guild_score
        Score.create!(points: score, battle_level_id: @battle_level.id,
                      scorapable_type: 'Guild', scorapable_id: @guild.id)
      else
        @guild_score += score
        @guild_score.save
      end
    else
    end
  end
end