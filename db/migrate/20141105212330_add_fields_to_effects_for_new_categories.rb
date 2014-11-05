class AddFieldsToEffectsForNewCategories < ActiveRecord::Migration
  def change
    add_column :effects, :duration, :integer, default: 0
    add_column :effects, :restore, :string, default: "0"
  end
end
