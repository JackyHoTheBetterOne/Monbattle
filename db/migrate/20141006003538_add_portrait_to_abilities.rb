class AddPortraitToAbilities < ActiveRecord::Migration
  def change
    add_attachment :abilities, :portrait
  end
end
