class AddPersonalityToMonsters < ActiveRecord::Migration
  def change
    add_reference :monsters, :personality, index: true
  end
end
