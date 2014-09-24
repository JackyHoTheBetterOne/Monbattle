class RemoveImageUrlFromAbilities < ActiveRecord::Migration
  def change
    remove_column :abilities, :image_url, :string
  end
end
