class AbilityEquippingForUsersController < ApplicationController
  before_action :find_monster_unlock
  before_action :find_ability
  before_action :find_socket_num
  before_action :find_abilities
  before_action :find_ability_equippings
  before_action :find_ability_equipping, only: [:update]

  def create
    render text: "Trying to create"
    # @ability_equipping = AbilityEquipping.new ability_equipping_params
    # if @ability_equipping.save
    #   render :action
    # else
    #   render :new
    # end
  end

  def update
    @ability_equipping.update_attributes(ability_equipping_params)
    respond_to do |format|
      if @ability_equipping.save
         format.js { render :action }
         format.html { render :new }
      else
        format.js { render :new }
      end
    end
  end

  private

  def find_ability_equipping
    @ability_equipping = AbilityEquipping.find params[:id]
  end

  def find_ability
    @ability = Ability.find params[:ability_equipping][:ability_id]
  end

  def find_monster_unlock
    @monster_unlock = MonsterUnlock.find params[:ability_equipping][:monster_unlock_id]
  end

  def find_socket_num
    @socket_num = (params[:ability_equipping][:socket_num]).to_i
  end

  def find_abilities
    @abilities = Ability.all
  end

  def find_ability_equippings
    @ability_equippings = AbilityEquipping.all
  end

  def ability_equipping_params
    params.require(:ability_equipping).permit(:monster_unlock_id, :ability_id)
  end
end