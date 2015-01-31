class Battle::Create
  include Virtus.model
  attribute :user, User
  attribute :summoner, Summoner
  attribute :battle_params, Hash

  attribute :battle, Battle

  def call
    if user.parties[0].battles.count == -1
      self.battle = Battle.new
      battle.battle_level_id = 99999999999999
      battle.parties.push(Party.where(name: "ur sister dead")[0])
      battle.parties.push(Party.where(name: "me raping ur sister")[0])
    else
      self.battle = Battle.new battle_params
      battle.parties.push(Party.find_by_user_id(user.id))
      battle.parties.push(
        Party.where(user: User.find_by_user_name("NPC")).
        where(name: battle.battle_level.name).
        where(enemy: user.user_name).last)
    end
  end
end