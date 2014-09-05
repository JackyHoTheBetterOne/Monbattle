class AdminController < ApplicationController

  def index
    @evolved_state = EvolvedState.new
    @evolved_states = EvolvedState.all
    @monster = Monster.new
    @monsters = Monster.all
    @target = Target.new
    @targets = Target.all
    @element= Element.new
    @elements = Element.all
    @job = Job.new
    @jobs = Job.all
    @effect = Effect.new
    @effects = Effect.all
    @ability = Ability.new
    @abilities = Ability.all
  end



end
