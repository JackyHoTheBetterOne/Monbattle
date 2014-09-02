class RemoveElementFromMonster < ActiveRecord::Migration
  def change
    remove_column :monsters, :job, :string
    remove_column :monsters, :element, :string
  end
end
