class RaritiesController < ApplicationController

  def create
    @rarity = Rarity.new rarity_params
    @rarity.save
    redirect_to monsters_path
  end

  def destroy
    @rarity = Rarity.find params[:id]
    @rarity.destroy
    redirect_to monsters_path
  end

  private

  def rarity_params
    params.require(:rarity).permit(:name)
  end

end