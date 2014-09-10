class MonstersController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_monster, only: [:destroy, :edit, :evolve_edit]

  def create
    @monster = Monster.new monster_params
    @monster.
    respond_to do |format|
      if @monster.save
        format.html {redirect_to admin_index_path, notice: "Monster saved"}
        if format.js == true
          if @monster.evolved_from_id == "0"
            format.js { render }
          elsif @monster.evolved_from_id == "1"
            # render to evolved format.js { render }
          else
            format.html { redirect_to admin_index_path, notice: "Failed!" }
          end
        end
      else 
        format.html {redirect_to admin_index_path, notice: "Failed!"}
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

  def evolve_edit
  end

  private

  def find_monster
    @monster = Monster.find params[:id]
  end

  def monster_params
    params.require(:monster).permit(:name, :max_hp, {user_ids: []}, :monster_skin_id, :job_id, :element_id, :description, :evolved_from_id, :hp_modifier, :dmg_modifier, {ability_ids: []})
  end
end
