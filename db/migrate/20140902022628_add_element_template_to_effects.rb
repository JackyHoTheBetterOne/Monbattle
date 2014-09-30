class AddElementTemplateToEffects < ActiveRecord::Migration
  def change
    add_reference :effects, :element_template, index: true
  end
end
