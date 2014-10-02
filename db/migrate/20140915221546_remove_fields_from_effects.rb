class RemoveFieldsFromEffects < ActiveRecord::Migration
  def change
    remove_column :effects, :damage, :integer
    remove_column :effects, :modifier, :integer
  end
end
