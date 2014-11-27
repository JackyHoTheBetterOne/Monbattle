class AddKeywordsToBattleLevelsAndAreas < ActiveRecord::Migration
  def change
    add_column :battle_levels, :keywords, :text
    add_column :areas, :keywords, :text
  end
end
