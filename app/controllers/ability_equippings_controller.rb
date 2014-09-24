class AbilityEquippingsController < ApplicationController
  before_action :find_ability_equipping, only: [:update]
  before_action :find_party

  def create
    @ability_equipping = AbilityEquipping.new ability_equipping_params
    if @ability_equipping.save
      redirect_to @party, notice: "hurrah"
    else
      redirect_to @party, notice: "You fail"
    end
  end

  def update
    @ability_equipping.update_attributes(ability_equipping_params)
    if @ability_equipping.save
      redirect_to @party, notice: "hurrah"
    else
      redirect_to @party, notice: "You fail"
    end
  end

  private

  def find_ability_equipping
    @ability_equipping = AbilityEquipping.find params[:id]
  end

  def find_party
    @party = Party.find params[:ability_equipping][:party_id]
  end

  def ability_equipping_params
    params.require(:ability_equipping).permit(:user_id, :ability_id, :monster_id)
  end

end
