class MonstersController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_monster, except: [:create]

  def create
    @monster = Monster.new monster_params
    respond_to do |format|
      if @monster.save
        format.html {redirect_to admin_index_path, notice: "Monster saved"}
        format.js { render }
      else
        format.html {redirect_to admin_index_path, notice: "Failed!"}
        format.js { render}
      end
    end
  end

  def destroy
    if @monster.destroy
      respond_to do |format|
        format.html {redirect_to admin_index_path, notice: "Monster Removed"}
        format.js { render }
      end
    else
      redirect_to admin_index_path, notice: "Failure"
    end
  end

  # def clone
  #   # render text: params.to_s
  #   @monster = Monster.find(params[:id])
  #   @monster = Monster.new(@monster.attributes)
  #   render :clone
  # end

  def edit
  end

  def update
    @monster.update_attributes(monster_params)
    if @monster.save
      @monster.ability_equippings.destroy_all
      @monster.members.destroy_all
      redirect_to admin_index_path, notice: "Also Destroyed all Ability Equipping Associations and Party Associations!"
    end
  end

  private

  def find_monster
    @monster = Monster.find params[:id]
  end

  def monster_params
    params.require(:monster).permit(:name, :max_hp, :monster_skin_id, :job_id, :element_id, :description, :evolved_from_id, :hp_modifier, :dmg_modifier)
  end

end
