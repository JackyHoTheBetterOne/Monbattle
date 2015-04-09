class AddKeywordsToGuild < ActiveRecord::Migration
  def change
    add_column :guilds, :keywords, :text
  end
end
