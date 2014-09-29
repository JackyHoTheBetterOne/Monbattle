class AddImageToMonsters < ActiveRecord::Migration
  def change
    add_attachment :monsters, :evolve_animation
  end
end
