class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.boolean :purchased
      t.belongs_to :flight
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
