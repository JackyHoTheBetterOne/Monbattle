class AddSoundToAbility < ActiveRecord::Migration
  def change
    add_column :abilities, :sound, :text, default: "https://s3-us-west-2.amazonaws.com/monbattle/music/button-press-sound-fx.wav"
    add_column :monsters, :evolve_sound, :text, default: "https://s3-us-west-2.amazonaws.com/monbattle/music/button-press-sound-fx.wav"
  end
end
