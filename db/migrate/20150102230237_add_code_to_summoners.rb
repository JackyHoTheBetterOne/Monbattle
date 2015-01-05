class AddCodeToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :code, :string
  end
end
