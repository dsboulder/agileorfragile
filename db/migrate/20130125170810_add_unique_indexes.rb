class AddUniqueIndexes < ActiveRecord::Migration
  def up
    #add_index :stories, [:taken_on, :tracker_id], :unique => true
    #add_index :iterations, [:taken_on, :project_id, :number], :unique => true
  end

  def down
  end
end
