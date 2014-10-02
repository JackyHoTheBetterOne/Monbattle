class AddAttachmentToAbilities < ActiveRecord::Migration
  def change
    add_attachment :abilities, :image
  end
end
