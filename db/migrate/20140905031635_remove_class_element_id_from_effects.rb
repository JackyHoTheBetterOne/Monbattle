class RemoveClassElementIdFromEffects < ActiveRecord::Migration
  def change
    remove_reference :effects, :element_template, index: true
  end
end
