class ElementTemplatesController < ApplicationController
  # before action :authenticate!

  def create
    @element_template = ElementTemplate.new element_template_params
    @element_template.save
    redirect_to admin_index_path
  end

  def destroy
    @element_template = ElementTemplate.find params[:id]
    @element_template.destroy
    redirect_to admin_index_path
  end

private

  def element_template_params
    params.require(:element_template).permit(:name)
  end

end
