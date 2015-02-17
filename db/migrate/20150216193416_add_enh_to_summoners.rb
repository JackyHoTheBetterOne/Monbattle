class AddEnhToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :enh, :integer, default: 0
  end
end
