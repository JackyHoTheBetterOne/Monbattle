class AddDescriptionToEffects < ActiveRecord::Migration
  def change
    add_column :effects, :description, :text
  end
end
