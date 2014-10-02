class AddJobToAbilities < ActiveRecord::Migration
  def change
    add_column :abilities, :job, :string
  end
end
