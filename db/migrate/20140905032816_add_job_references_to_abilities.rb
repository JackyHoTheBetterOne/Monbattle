class AddJobReferencesToAbilities < ActiveRecord::Migration
  def change
    add_reference :abilities, :job, index: true
  end
end
