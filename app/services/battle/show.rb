class Battle::Show
  include Virtus.model
  attribute :battle, Battle
  attribute :battle_level, BattleLevel
  attribute :summoner, Summoner

  attribute :user_party
  attribute :pc_party
  attribute :first_cleared
  attribute :twice_cleared
  attribute :show_ap_button
  attribute :show_oracle_skill
  attribute :oracle_skill_turtorial
  attribute :has_cut_scene
  attribute :is_first_battle

  def call 
    self.user_party = battle.parties[0]
    self.pc_party   = battle.parties[1]
    self.battle_level = battle.battle_level

    if summoner.played_levels.include?(battle_level.name) && battle_level.
        has_cut_scene
      self.has_cut_scene = true
    else
      self.has_cut_scene = false
    end

    if battle_level.name == "First battle"
      self.is_first_battle = true
    else
      self.is_first_battle = false
    end

    if summoner.beaten_levels.include?(battle.battle_level.name) && 
        !summoner.cleared_twice_levels.include?(battle.battle_level.name)
      self.first_cleared = true
    else
      self.first_cleared = false
    end

    if summoner.cleared_twice_levels.include?(battle.battle_level.name)
      self.twice_cleared = true
    else
      self.twice_cleared = false
    end

    if battle.battle_level.name == "First battle" 
      self.show_ap_button = false
    else
      self.show_ap_button = true
    end

    if battle.battle_level.name == "Area A - Stage 1" || battle.battle_level.name == "Area A - Stage 2" ||
      battle.battle_level.name == "Area A - Stage 3" || battle.battle_level.name == "First battle"
      self.show_oracle_skill = false
    else
      self.show_oracle_skill = true
    end

    if battle.battle_level.name == "Area A - Stage 4"
      self.oracle_skill_turtorial = true
    else
      self.oracle_skill_turtorial = false
    end
  end
end