class CreateIterations < ActiveRecord::Migration
  def change
    create_table :iterations do |t|
      t.integer :project_id
      t.integer :number
      t.datetime :start
      t.datetime :finish
      t.string :kind

      t.date :taken_on

      t.timestamps
    end

    add_index :iterations, [:project_id, :kind]
  end
end
