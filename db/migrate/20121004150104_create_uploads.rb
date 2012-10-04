class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :filename
      t.text :content
      t.timestamps
    end
  end
end
