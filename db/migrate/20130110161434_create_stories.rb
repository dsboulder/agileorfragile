class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer :project_id
      t.integer :iteration_id
      t.integer :estimate
      t.string :name
      t.string :tracker_id
      t.string :url
      t.string :current_state
      t.string :story_type
      t.string :requested_by
      t.string :owned_by
      t.string :tracker_labels

      t.datetime :tracker_created_at
      t.date :taken_on

      t.timestamps
    end

    add_index :stories, [:project_id, :iteration_id]
    add_index :stories, [:project_id, :taken_on]
  end
end
