class AddKeyword < ActiveRecord::Migration
  def change
    add_column :monsters, :keywords, :text
    add_column :abilities, :keywords, :text
    add_column :effects, :keywords, :text
  end
end
