class AddRetainedToCards < ActiveRecord::Migration
  def change
    add_column :cards, :retained, :boolean
  end
end
