class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.string :destination
      t.decimal :price, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
