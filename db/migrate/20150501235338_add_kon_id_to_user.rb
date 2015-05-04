class AddKonIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :kon_id, :text, default: ""
    add_index :users, :kon_id
  end
end
