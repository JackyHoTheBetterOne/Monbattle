class ThoughtsController < ApplicationController
  before_action :find_personality
  before_action :find_thought, except: [:create]

  def create
    @thought = Thought.new thought_params
    @thought.personality = @personality
    respond_to do |format|
      if @thought.save
        format.html { redirect_to personalities_path }
        format.js { render }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @thought.destroy
        format.html { redirect_to personalities_path }
        format.js { render }
      end
    end
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
