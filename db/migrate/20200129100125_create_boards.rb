class CreateBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :boards do |t|
      t.integer :row
      t.integer :column
      t.string :move_by
      t.string :symbol
      t.integer :game_id
      t.datetime :move_time

      t.timestamps
    end
  end
end
