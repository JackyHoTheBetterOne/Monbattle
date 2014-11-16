class AddReferenceOnChapters < ActiveRecord::Migration
  def change
    add_reference :chapters, :arc, index: true
  end
end
