class AddFormerNameToAbilitiesAndMonsterSkins < ActiveRecord::Migration
  def change
    add_column :abilities, :former_name, :text, default: ""
    add_column :monster_skins, :former_name, :text, default: ""
  end
end
