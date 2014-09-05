class RemoveTargetFromEffects < ActiveRecord::Migration
  def change
    remove_column :effects, :target, :string
  end
end
