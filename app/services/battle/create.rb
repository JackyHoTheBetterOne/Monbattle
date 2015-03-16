class Battle::Create
  include Virtus.model
  attribute :user, User
  attribute :summoner, Summoner
  attribute :battle_params, Hash

  attribute :battle, Battle

  def call
    self.user = summoner.user
    if summoner.played_levels.length == 0
      @pc_party = Party.find_by_name("first-battle-pc")

      if @pc_party.monster_unlocks.count != 4 
        @dynamis = MonsterUnlock.where("user_id = 2 AND monster_id = 83")[0]
        @ironhyde = MonsterUnlock.where("user_id = 2 AND monster_id = 81")[0]
        @kiryia = MonsterUnlock.where("user_id = 2 AND monster_id = 82")[0]
        @tricera = MonsterUnlock.where("user_id = 2 AND monster_id = 80")[0]

        array = @pc_party.monster_unlocks

        @pc_party.monster_unlocks << @dynamis if !array.include?(@dynamis)
        @pc_party.monster_unlocks << @ironhyde if !array.include?(@ironhyde)
        @pc_party.monster_unlocks << @kiryia if !array.include?(@kiryia)
        @pc_party.monster_unlocks << @tricera if !array.include?(@tricera)

      end
      self.battle = Battle.new
      self.battle.admin = true if user.email == "muffintopper420@mombattle.com"
      battle.battle_level_id = 30
      battle.parties.push(Party.find_by_name("first-battle-user"))
      battle.parties.push(Party.find_by_name("first-battle-pc"))
    else
      self.battle = Battle.new battle_params
      self.battle.admin = true if self.user.email == "muffintopper420@mombattle.com"
      battle.parties.push(Party.find_by_user_id(user.id))
      battle.parties.push(
        Party.where(user: User.find_by_user_name("NPC")).
        where(name: battle.battle_level.name).
        where(enemy: user.email).last
      )
    end
  end
end