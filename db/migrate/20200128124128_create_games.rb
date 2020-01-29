class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :board_size
      t.integer :status
      t.string :winner

      t.timestamps
    end
  end
end
