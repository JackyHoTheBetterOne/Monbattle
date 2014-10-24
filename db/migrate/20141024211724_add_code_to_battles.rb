class AddCodeToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :id_code, :string
  end
end
