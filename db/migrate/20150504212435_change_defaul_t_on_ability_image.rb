class ChangeDefaulTOnAbilityImage < ActiveRecord::Migration
  def change
    remove_column :abilities, :image
    add_column :abilities, :image, :string, default: "https://arcane-depths-3003.herokuapp.com/images/dark-bomb.svg"
  end
end
