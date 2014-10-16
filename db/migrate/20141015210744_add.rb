class Add < ActiveRecord::Migration
  def change
    add_column :summoners, :vortex_key, :integer, default: 0
  end
end
