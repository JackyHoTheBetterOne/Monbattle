class AdminController < ApplicationController

  def index
    @element_template = ElementTemplate.new
    @element_templates = ElementTemplate.all
    @class_template = ClassTemplate.new
    @class_templates = ClassTemplate.all
    @monster_template = MonsterTemplate.new
    @monster_templates = MonsterTemplate.all
    @effect = Effect.new
    @effects = Effect.all
    @ability = Ability.new
    @abilities = Ability.all
  end



end
