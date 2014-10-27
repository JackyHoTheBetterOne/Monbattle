class MonsterSkinsController < ApplicationController
  before_action :find_monster_skin, except: [:create, :index]

  def index
    @monster_skin = MonsterSkin.new
    @monster_skins = MonsterSkin.all
    @monster_skin_purchase = MonsterSkinPurchase.new
  end

  def create
    # render text: params.to_s
    @monster_skin = MonsterSkin.new monster_skin_params
    authorize @monster_skin
    if @monster_skin.save
      redirect_to monster_skins_path, notice: "Skin Added!"
    else
      redirect_to monster_skins_path, notice: "You fail"
    end
  end

  def edit
  end

  def update
    authorize @monster_skin
    @monster_skin.update_attributes(monster_skin_params)
    if @monster_skin.save
      # @monster_skin.monster_skin_equippings.destroy_all
      redirect_to monster_skins_path, notice: "Previous skin restrictions destroyed, new skin restrictions added!"
    end
  end

  def destroy
    # render text: params.to_s
    authorize @monster_skin
    if @monster_skin.destroy
      redirect_to monster_skins_path, notice: "Monster Skin Destroyed!!!"
    end
  end

  private

  def monster_skin_params
    params.require(:monster_skin).permit(:avatar, :name, :portrait, :rarity_id, :former_name, {job_ids: []})
  end

  def find_monster_skin
    @monster_skin = MonsterSkin.find params[:id]
  end
end
