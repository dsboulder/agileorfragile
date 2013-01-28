class AddExtrasToIterations < ActiveRecord::Migration
  def change
    add_column :iterations, :iteration_length, :integer
    add_column :iterations, :team_strength, :float
  end
end
