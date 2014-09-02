class RemoveElementFromEffects < ActiveRecord::Migration
  def change
    remove_column :effects, :element, :string
  end
end
