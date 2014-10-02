class RemoveReferencesFights < ActiveRecord::Migration
  def change
    remove_reference :fights, :user, index: true
  end
end
