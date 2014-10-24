class MonstersController < ApplicationController
  before_action :find_monster, except: [:index, :create]

  def index
    @monster_unlock = MonsterUnlock.new
    @rarity = Rarity.new
    @rarities = Rarity.all
    @job = Job.new
    @jobs = Job.all
    @element = Element.new
    @elements = Element.all
    @monster = Monster.new
    @personality = Personality.new
    @personalities = Personality.all
    @monsters = Monster.includes(:job, :element, :personality).search(params[:keyword]).
                paginate(:page => params[:page], :per_page => 15)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @monster = Monster.new monster_params
    @monsters = Monster.all
    @job = Job.new
    @jobs = Job.all
    @element = Element.new
    @elements = Element.all
    authorize @monster
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
    authorize @monster
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
    authorize @monster
    @monster.update_attributes(monster_params)
    respond_to do |format|
      # @monster.save
      # p "==============="
      # p @monster.errors.full_messages
      # p "==============="
      if @monster.save
        format.html { redirect_to monsters_path, notice: "Updated!" }
      else
        format.html { render :new }
      end
    end
  end

  private

  def find_monster
    @monster = Monster.find params[:id]
  end

  def monster_params
    params.require(:monster).permit(
                                    :name, :max_hp, :monster_skin_id, :job_id, :element_id, :description, :rarity_id,
                                    :personality_id, :evolved_from_id, :hp_modifier, :dmg_modifier, :summon_cost,
                                    :evolve_animation, :gp_cost, :mp_cost
                                    )
  end

end


