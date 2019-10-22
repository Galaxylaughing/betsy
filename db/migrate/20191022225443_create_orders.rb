class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :email
      t.string :address
      t.string :name
      t.string :cc_num
      t.string :cvv_code
      t.string :zip

      t.timestamps
    end
  end
end
