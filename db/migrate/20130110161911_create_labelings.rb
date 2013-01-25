class CreateLabelings < ActiveRecord::Migration
  def change
    create_table :labelings do |t|
      t.integer :story_id
      t.integer :project_id
      t.integer :label_id
      t.date :taken_on
      t.timestamps
    end

    add_index :labelings, :project_id
    add_index :labelings, :label_id
    add_index :labelings, :story_id
  end
end
