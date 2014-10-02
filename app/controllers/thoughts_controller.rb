class ThoughtsController < ApplicationController
  before_action :find_personality
  before_action :find_thought, except: [:create]

  def create
    # render text: params.to_s
    @thought = Thought.new thought_params
    @thought.personality = @personality
    if @thought.save
      redirect_to personalities_path
    else
      render :new
    end
  end

  def destroy
    @thought.destroy
    redirect_to personalities_path
  end

  private

  def find_thought
    @thought = Thought.find params[:id]
  end

  def find_personality
    @personality = Personality.find params[:personality_id]
  end

  def thought_params
    params.require(:thought).permit(:comment)
  end

end
