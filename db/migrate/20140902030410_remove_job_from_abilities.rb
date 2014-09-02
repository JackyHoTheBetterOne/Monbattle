class RemoveJobFromAbilities < ActiveRecord::Migration
  def change
    remove_column :abilities, :job, :string
  end
end
