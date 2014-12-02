class Battle::Judgement

  include Virtus.model

  attribute :battle, Battle
  attribute :message

  def call
    if battle.after_action_state != battle.before_action_state
      self.message = "Your fucked"
    else
      self.message = "Your good"
      battle.is_hacked = false
    end
    battle.save
  end
end
