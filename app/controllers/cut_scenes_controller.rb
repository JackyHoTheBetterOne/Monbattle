class CutScenesController < ApplicationController
  before_action :find_cut_scene, only: [:update, :destroy]

  def index
    @cut_scenes = policy_scope(CutScene.search(params[:keyword]).order("to_start DESC").order(:order).
                    paginate(:page => params[:page], :per_page => 20))
    @cut_scene = CutScene.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @cut_scene = CutScene.new cut_scene_params
    authorize @cut_scene
    @cut_scene.save
    respond_to do |format|
      format.js
    end
  end

  def update
    authorize @cut_scene
    @cut_scene.update_attributes(cut_scene_params)
    @cut_scene.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
    authorize @cut_scene
    if @cut_scene.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  private
  def cut_scene_params
    params.require(:cut_scene).permit(:name, :description, :to_start, :image, :chapter_id, :battle_level_id, :order)
  end

  def find_cut_scene
    @cut_scene = CutScene.find(params[:id])
  end
end
