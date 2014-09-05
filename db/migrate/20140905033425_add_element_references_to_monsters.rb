class AddElementReferencesToMonsters < ActiveRecord::Migration
  def change
    add_reference :monsters, :element, index: true
  end
end
