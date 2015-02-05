class Battle::Create
  include Virtus.model
  attribute :user, User
  attribute :summoner, Summoner
  attribute :battle_params, Hash

  attribute :battle, Battle

  def call
    if user.summoner.played_levels.length == 0
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
        where(enemy: user.email).last)
    end
  end
end