class AddMapToAreas < ActiveRecord::Migration
  def change
    add_attachment :areas, :map
  end
end
