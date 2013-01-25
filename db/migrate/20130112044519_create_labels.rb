class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.timestamps
    end

    add_index :labels, :name
  end
end
