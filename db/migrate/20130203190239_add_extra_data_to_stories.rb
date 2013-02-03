class AddExtraDataToStories < ActiveRecord::Migration
  def change
    add_column :stories, :comments, :integer, :default => 0
    add_column :stories, :unfinished_tasks, :integer, :default => 0
    add_column :stories, :finished_tasks, :integer, :default => 0
  end
end
