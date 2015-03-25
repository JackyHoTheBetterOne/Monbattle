class RidOfEvolveAnimation < ActiveRecord::Migration
  def change
    remove_attachment :monsters, :evolve_animation
    add_column :monsters, :evolve_animation, :string, default: "https://s3-us-west-2.amazonaws.com/monbattle/images/ability_animation/evolution.svg"
  end
end
