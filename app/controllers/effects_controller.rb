class EffectsController < ApplicationController
  before_action :find_effect, except: [:create, :index]

  def index
    @effect = Effect.new
    @effects = Effect.all
  end

  def create
    @effect = Effect.new effect_params
    authorize @effect
    if @effect.save
      redirect_to effects_path, notice: "Effect Added"
    else
      redirect_to effects_path, notice: "Failure"
    end
  end

  def destroy
    authorize @effect
    if @effect.destroy
      redirect_to effects_path, notice: "Effect Removed"
    else
      redirect_to effects_path, notice: "Failure"
    end
  end

  def edit
  end

  def update
    authorize @effect
    @effect.update_attributes(effect_params)
    if @effect.save
      redirect_to effects_path, notice: "Success!"
    end
  end

private

  def effect_params
    params.require(:effect).permit(:name, :target_id, :element_id, :stat_target_id, :stat_change)
  end

  def find_effect
    @effect = Effect.find params[:id]
  end

end
