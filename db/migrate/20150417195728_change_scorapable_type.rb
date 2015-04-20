class ChangeScorapableType < ActiveRecord::Migration
  def change
    remove_column :scores, :scorapable_type
    add_column :scores, :scorapable_type, :string
  end
end
