class AddBeatenLevelsToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :beaten_levels, :text, array: true
  end
end
