class DropElenents < ActiveRecord::Migration
  def change
    drop_table :elenents
  end
end
