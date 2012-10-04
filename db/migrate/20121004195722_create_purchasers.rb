class CreatePurchasers < ActiveRecord::Migration
  def change
    create_table :purchasers do |t|
      t.text :name

      t.timestamps
    end
  end
end
