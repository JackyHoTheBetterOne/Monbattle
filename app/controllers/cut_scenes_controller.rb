class CutScenesController < ApplicationController
  def index
    @cut_scenes = policy_scope(CutScene.all)
  end

  def create
    @cut_scene = CutScene.new cut_scene_params
    @cut_scene.save
    render nothing: true
  end

  def update
  end

  def destroy
  end

  private
  def cut_scene_params
    params.require(:cut_scene).permit(:name, :description, :to_start, :image, :chapter_id, :battle_level_id)
  end
end
