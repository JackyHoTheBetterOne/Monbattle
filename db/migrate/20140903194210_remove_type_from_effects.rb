class RemoveTypeFromEffects < ActiveRecord::Migration
  def change
    remove_column :effects, :type, :string
  end
end
