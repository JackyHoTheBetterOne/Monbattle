class CreateStatTargets < ActiveRecord::Migration
  def change
    create_table :stat_targets do |t|
      t.string :name

      t.timestamps
    end
  end
end
