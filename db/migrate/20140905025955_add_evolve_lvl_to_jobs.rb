class AddEvolveLvlToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :jobs, :string
  end
end
