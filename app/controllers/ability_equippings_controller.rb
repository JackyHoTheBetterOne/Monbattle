class AbilityEquippingsController < ApplicationController
  before_action :find_party
  before_action :find_monster
  before_action :find_user
  before_action :find_ability_equipping, only: [:update]

  def create
    @ability_equipping = AbilityEquipping.new ability_equipping_params
    respond_to do |format|
      if @ability_equipping.save
        format.html { redirect_to @party, notice: "Equipped Ability" }
        format.js { render :action }
      else
        redirect_to @party, notice: "You fail"
      end
    end
  end

  def update
    @ability_equipping.update_attributes(ability_equipping_params)
    respond_to do |format|
      if @ability_equipping.save
        format.html { redirect_to @party, notice: "Changed Ability Equipped in Socket" }
        format.js { render :action }
      else
        redirect_to @party, notice: "You fail"
      end
    end
  end

  private

  def find_ability_equipping
    @ability_equipping = AbilityEquipping.find params[:id]
  end

  def find_user
    @user = User.find params[:ability_equipping][:user_id]
  end

  def find_party
    @party = Party.find params[:ability_equipping][:party_id]
  end

  def find_monster
    @monster = Monster.find params[:ability_equipping][:monster_id]
  end

  def ability_equipping_params
    params.require(:ability_equipping).permit(:monster_unlock_id, :ability_id)
  end

end
