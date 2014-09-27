class ElementsController < ApplicationController

  def create
    @element = Element.new element_params
    @element.save
    redirect_to monsters_path
  end

  def destroy
    @element = Element.find params[:id]
    @element.destroy
    redirect_to monsters_path
  end

private

  def element_params
    params.require(:element).permit(:name)
  end
end


