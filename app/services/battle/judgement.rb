class Battle::Judgement
  include Virtus.model

  attribute :params, Hash
  attribute :battle, Battle
  attribute :message

  def call
    battle.update_attributes(params)
    if battle.after_action_state != battle.before_action_state
      self.message = "This game is hacked."
      battle.ruined
    else
      self.message = "Your good"
      battle.is_hacked = false
    end
    battle.save
  end
end

