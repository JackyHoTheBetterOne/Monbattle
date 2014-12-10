class AddAttachmentToMaps < ActiveRecord::Migration
  def change
    remove_attachment :areas, :map
    add_attachment :regions, :map
  end
end
