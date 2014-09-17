class AddReferencesFights < ActiveRecord::Migration
  def change
    add_reference :fights, :party, index: true
  end
end
