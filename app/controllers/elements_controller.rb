class ElementsController < ApplicationController
  # before action :authenticate!

  def create
    @element = Element.new element_params
    @element.save
    redirect_to admin_index_path
  end

  def destroy
    @element = Element.find params[:id]
    @element.destroy
    redirect_to admin_index_path
  end

private

  def element_params
    params.require(:element).permit(:name)
  end
end


