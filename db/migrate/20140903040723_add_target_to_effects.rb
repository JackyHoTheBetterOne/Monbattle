class AddTargetToEffects < ActiveRecord::Migration
  def change
    add_reference :effects, :target, index: true
  end
end
