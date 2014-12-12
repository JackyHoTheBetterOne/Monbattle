class AddAttachmentToNotice < ActiveRecord::Migration
  def change
    add_attachment :notices, :banner
    add_attachment :notices, :description_image
  end
end
