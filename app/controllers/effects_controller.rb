class EffectsController < ApplicationController
  # before_action :authenticate!
  before_action :find_effect, except: [:create]

  def create
    @effect = Effect.new effect_params
    if @effect.save
      redirect_to admin_index_path, notice: "Effect Removed"
    else
      redirect_to admin_index_path, notice: "Failure"
    end
  end

  def destroy
    if @effect.destroy
      redirect_to admin_index_path, notice: "Effect Removed"
    else
      redirect_to admin_index_path, notice: "Failure"
    end
  end

  def edit
  end

  def update
    @effect.update_attributes(effect_params)
    if @effect.save
      redirect_to admin_index_path, notice: "Success!"
    end
  end

private

  def effect_params
    params.require(:effect).permit(:name, :target_id, :element_id, :damage, :modifier)
  end

  def find_effect
    @effect = Effect.find params[:id]
  end

end
