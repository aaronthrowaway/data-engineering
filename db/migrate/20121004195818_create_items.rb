class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.text :description
      t.decimal :price
      t.integer :merchant_id

      t.timestamps
    end
  end
end
