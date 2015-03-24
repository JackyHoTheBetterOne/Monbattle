class ReplaceAttachmentImageOnAbilities < ActiveRecord::Migration
  def change
    remove_attachment :abilities, :image
    add_column :abilities, :image, :string, default: "https://s3-us-west-2.amazonaws.com/monbattle/images/ability_animation/dark-bomb.svg"
  end
end
