class AddKeywordsToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :keywords, :text
  end
end
