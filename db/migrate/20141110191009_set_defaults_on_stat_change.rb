class SetDefaultsOnStatChange < ActiveRecord::Migration
  def change
    change_column :abilities, :stat_change, :string, default: ""
    change_column :effects, :stat_change, :string, default: ""
  end
end
