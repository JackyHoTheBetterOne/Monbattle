class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :evolve_lvl

      t.timestamps
    end
  end
end
