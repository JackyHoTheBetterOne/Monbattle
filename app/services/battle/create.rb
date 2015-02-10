class Battle::Create
  include Virtus.model
  attribute :user, User
  attribute :summoner, Summoner
  attribute :battle_params, Hash

  attribute :battle, Battle

  def call
    if user.summoner.played_levels.length == 0
      @pc_party = Party.find_by_name("first-battle-pc")

      if @pc_party.monster_unlocks.count != 4 
        @dynamis = MonsterUnlock.find(1361)
        @ironhyde = MonsterUnlock.find(1356)
        @kiryia = MonsterUnlock.find(1357)
        @raizer = MonsterUnlock.find(1345)

        array = @pc_party.monster_unlocks

        @pc_party.monster_unlocks << @dynamis if !array.include?(@dynamis)
        @pc_party.monster_unlocks << @ironhyde if !array.include?(@ironhyde)
        @pc_party.monster_unlocks << @kiryia if !array.include?(@kiryia)
        @pc_party.monster_unlocks << @raizer if !array.include?(@raizer)

      end
      self.battle = Battle.new
      battle.battle_level_id = 30
      battle.parties.push(Party.find_by_name("first-battle-user"))
      battle.parties.push(Party.find_by_name("first-battle-pc"))
    else
      self.battle = Battle.new battle_params
      battle.parties.push(Party.find_by_user_id(user.id))
      battle.parties.push(
        Party.where(user: User.find_by_user_name("NPC")).
        where(name: battle.battle_level.name).
        where(enemy: user.email).last
      )
    end
  end
end