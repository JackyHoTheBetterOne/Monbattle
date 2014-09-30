class AddEvolvedFromToMonster < ActiveRecord::Migration
  def change
    add_reference :monsters, :evolved_from, index: true
  end
end
