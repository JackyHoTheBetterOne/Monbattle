class DeleteEffectIconAttachment < ActiveRecord::Migration
  def change
    remove_attachment :effects, :icon
  end
end
