class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.belongs_to :booking
      t.belongs_to :card
      t.timestamps null: false
    end
  end
end
