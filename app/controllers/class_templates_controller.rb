class ClassTemplatesController < ApplicationController
  # before action :authenticate!

  def create
    @class_template = ClassTemplate.new class_template_params
    @class_template.save
    redirect_to admin_index_path
  end

  def destroy
    @class_template = ClassTemplate.find params[:id]
    @class_template.destroy
    redirect_to admin_index_path
  end

private

  def class_template_params
    params.require(:class_template).permit(:name)
  end

end
