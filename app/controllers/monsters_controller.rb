class MonstersController < ApplicationController
  before_action :find_monster, except: [:index, :create]
  before_action :name_check, only: [:update]
  before_action :find_monsters, :new_monster_unlock, :find_rarities, :find_levels, :find_jobs, :find_elements,
                :find_personalities, :find_abilities, :find_monster_skins

  def index
    @monster = Monster.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @monster = Monster.new monster_params
    @monster.set_defaults
    authorize @monster
    respond_to do |format|
      if @monster.save
        format.html { redirect_to monsters_path, notice: "Monster saved" }
        format.js { render }
      else
        @monster.errors.full_messages.each do |msg|
          p msg
        end
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

  def update
    authorize @monster
    @monster.update_attributes(monster_params)
    respond_to do |format|
      # @monster.save
      # p "==============="
      # p @monster.errors.full_messages
      # p "==============="
      if @monster.save
        format.js
      else
        @monster.errors.full_messages.each do |msg|
          p msg
        end
      end
    end
  end

  def show
    if current_user.admin
      respond_to do |format|
        format.json {render json: @monster}
      end
    end
  end

  private

  def find_monsters
    @monsters = policy_scope(Monster.includes(:job, :element, :personality, :battle_levels, :rarity).search(params[:keyword]).
            paginate(:page => params[:page], :per_page => 20))
  end

  def new_monster_unlock
    @monster_unlock = MonsterUnlock.new
  end

  def find_rarities
    @rarities = Rarity.alphabetical
  end

  def find_levels
    @levels = BattleLevel.all
  end

  def find_jobs
    @jobs = Job.alphabetical
  end

  def find_elements
    @elements = Element.alphabetical
  end

  def find_personalities
    @personalities = Personality.all
  end

  def find_abilities
    @abilities = Ability.alphabetical.includes(:abil_socket).includes(:ability_restrictions)
  end

  def find_monster_skins
    @monster_skins = MonsterSkin.includes(:skin_restrictions)
  end

  def name_check
    if Monster.default_monsters.include? @monster.name
      params[:monster][:name] = @monster.name
    end
  end

  def find_monster
    @monster = Monster.find params[:id]
  end

  def monster_params
    params.require(:monster).permit(
                                    :name, :max_hp, :monster_skin_id, :job_id, :element_id, :description, :rarity_id,
                                    :personality_id, :evolved_from_id, :hp_modifier, :dmg_modifier, :summon_cost,
                                    :evolve_animation, :gp_cost, :mp_cost, :default_skin_id, :default_sock1_id,
                                    :default_sock2_id, :default_sock3_id, :default_sock4_id, { battle_level_ids: []}
                                    )
  end

end
