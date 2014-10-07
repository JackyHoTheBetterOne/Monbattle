class PersonalitiesController < ApplicationController

  def index
    @personality = Personality.new
    @personalities = Personality.all
    @thought = Thought.new
    @thoughts = Thought.all
  end

  def create
    @personality = Personality.new personality_params
    authorize @personality
    @personality.save
    redirect_to personalities_path
  end

  def destroy
    authorize @personality
    @personality = Personality.find params[:id]
    @personality.destroy
    redirect_to personalities_path
  end

  private

  def personality_params
    params.require(:personality).permit(:name)
  end

end
