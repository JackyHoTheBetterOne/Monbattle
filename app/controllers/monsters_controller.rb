class MonstersController < ApplicationController
  before_action :find_monster, except: [:index, :create]

  def index
    @monster_unlock = MonsterUnlock.new
    @job = Job.new
    @jobs = Job.all
    @element = Element.new
    @elements = Element.all
    @monsters = Monster.all
    @monster = Monster.new
    @personality = Personality.new
    @personalities = Personality.all
  end

  def create
    @monster = Monster.new monster_params
    @monsters = Monster.all
    @job = Job.new
    @jobs = Job.all
    @element = Element.new
    @elements = Element.all
    respond_to do |format|
      if @monster.save
        format.html { redirect_to monsters_path, notice: "Monster saved" }
        format.js { render }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    if @monster.destroy
      respond_to do |format|
        format.html { redirect_to monsters_path, notice: "Monster Removed" }
        format.js { render }
      end
    else
      format.html { render :new }
    end
  end

  # def clone
  #   # render text: params.to_s
  #   @monster = Monster.find(params[:id])
  #   @monster = Monster.new(@monster.attributes)
  #   render :clone
  # end

  def update
    @monster.update_attributes(monster_params)
    respond_to do |format|
      if @monster.save
        format.html { redirect_to monsters_path, notice: "Updated!" }
      else
        ormat.html { render :new }
      end
    end
  end

  private

  def find_monster
    @monster = Monster.find params[:id]
  end

  def monster_params
    params.require(:monster).permit(
                                    :name, :max_hp, :monster_skin_id, :job_id, :element_id, :description,
                                    :personality_id, :evolved_from_id, :hp_modifier, :dmg_modifier, :summon_cost,
                                    :evolve_animation
                                    )
  end

end
