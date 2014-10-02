class RemoveJobsFromAbilities < ActiveRecord::Migration
  def change
    remove_reference :abilities, :job, index: true
  end
end
