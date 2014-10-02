class AddJobToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :job, :string
  end
end
