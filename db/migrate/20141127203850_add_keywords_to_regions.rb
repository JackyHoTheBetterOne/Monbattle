class AddKeywordsToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :keywords, :text
  end
end
