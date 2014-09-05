class AddJobReferencesToMonsters < ActiveRecord::Migration
  def change
    add_reference :monsters, :job, index: true
  end
end
