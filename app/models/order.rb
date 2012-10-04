class Order < ActiveRecord::Base
  attr_accessible :quantity, :item_id, :purchaser_id, :upload_id

  validates_presence_of :quantity
	validates_presence_of :upload_id
	validates_presence_of :item_id
	validates_presence_of :purchaser_id
	
  belongs_to :upload
  belongs_to :item

	def revenue
		return 0 if item.nil? || !item.price
  	item.price * quantity
	end
end

