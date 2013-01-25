class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :tracker_id
      t.integer :user_id
      t.string :name
      t.text :all_labels, :default => "", :null => false
      t.text :enabled_labels, :default => "", :null => false
      t.boolean :enabled
      t.datetime :last_snapshot_at
      t.integer :current_velocity

      t.timestamps
    end
    add_index :projects, :user_id
  end
end
