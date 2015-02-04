class AddNameyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :namey, :string
  end
end
