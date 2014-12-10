class AddSomeHstoreToSummoners < ActiveRecord::Migration
  def up
    execute "create extension hstore"
    add_column :summoners, :starting_status, :hstore
    add_column :summoners, :ending_status, :hstore
  end

  def down
    remove_column :summoners, :starting_status
    remove_column :summoners, :ending_status
  end
end
