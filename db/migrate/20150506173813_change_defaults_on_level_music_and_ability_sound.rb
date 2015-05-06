class ChangeDefaultsOnLevelMusicAndAbilitySound < ActiveRecord::Migration
  def change
    remove_column :battle_levels, :music
    add_column :battle_levels, :music, :text, default: "https://s3-us-west-2.amazonaws.com/monbattle/music/battle-music-leveled.mp3"
    remove_column :abilities, :sound
    add_column :abilities, :sound, :text, default: "https://s3-us-west-2.amazonaws.com/monbattle/music/hit-sound.wav"
  end
end
