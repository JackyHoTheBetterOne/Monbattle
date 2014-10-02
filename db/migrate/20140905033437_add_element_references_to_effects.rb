class AddElementReferencesToEffects < ActiveRecord::Migration
  def change
    add_reference :effects, :element, index: true
  end
end
