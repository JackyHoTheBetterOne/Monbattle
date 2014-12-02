class Battle::Validation

  include Virtus.model

  attribute :params, Hash
  attribute :battle, Battle
  attribute :message

  def call
    if params["after_action_state"]
      battle.update_attributes(params)
      p "==========================================================================="
      p "Preparation"
      p "==========================================================================="
      self.message = "Ready for validation"
    elsif params["before_action_state"]
      battle.update_attributes(params)
      if battle.after_action_state != battle.before_action_state
        self.message = "Your fucked"
      else
        self.message = "Your good"
      end
      p "==========================================================================="
      p "Validation"
      p "==========================================================================="
    end
    battle.save
  end
end
