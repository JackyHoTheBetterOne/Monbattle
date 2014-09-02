class MonsterTemplatesController < ApplicationController
  # before_action :authenticate!
  before_action :find_monster_template, only: [:destroy]

  def create
    @monster_template = MonsterTemplate.new
  end

  def destroy
    if @monster_template.destroy
      redirect_to admin_index_path, notice: "Monster Template Removed"
    else
      redirect_to admin_index_path, notice: "Failure"
    end
  end

  private

  def effect_template_params
    params.require(:effect).permit(:name, :target, :element_template_id, :damage, :modifier, :type)
  end

  def find_effect
    @effect = Effect.find params[:id]
  end

end
