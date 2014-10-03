class PersonalitiesController < ApplicationController

  def index
    @personality = Personality.new
    @personalities = Personality.all
    @thought = Thought.new
    @thoughts = Thought.all
  end

  def create
    @personality = Personality.new personality_params
    @personality.save
    redirect_to monsters_path
  end

  def destroy
    @personality = Personality.find params[:id]
    @personality.destroy
    redirect_to monsters_path
  end

  private

  def personality_params
    params.require(:personality).permit(:name)
  end

end
