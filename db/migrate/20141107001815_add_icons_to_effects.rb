class AddIconsToEffects < ActiveRecord::Migration
  def change
    add_attachment :effects, :icon
  end
end
