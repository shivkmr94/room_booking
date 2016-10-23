class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :room_type_id
      t.string :room_no
      t.timestamps null: false
    end
  end
end
