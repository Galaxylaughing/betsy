class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :description
      t.float :price
      t.string :photo_url
      t.integer :stock
      t.boolean :available, default: true
      
      t.timestamps
    end
  end
end
