class AddTargetAndStatTargetAndStatChangeAndElement < ActiveRecord::Migration
  def change
    add_column :abilities, :stat_change, :string
    add_reference :abilities, :target, index: true
    add_reference :abilities, :element, index: true
    add_reference :abilities, :stat_target, index: true
    add_column :effects, :stat_change, :string
    add_reference :effects, :stat_target, index: true
  end
end
