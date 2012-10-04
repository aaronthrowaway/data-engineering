class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :quantity
      t.integer :item_id
      t.integer :purchaser_id
      t.integer :upload_id

      t.timestamps
    end
  end
end
