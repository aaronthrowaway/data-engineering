class Upload < ActiveRecord::Base
  attr_accessible :content, 
                  :filename, 
                  :file

 	attr_accessor   :file

  validates_presence_of :filename
  validates_presence_of :content
  validate :verify_file_format

  has_many :orders

  def load
  	return if file.nil?

  	self.filename = file.original_filename
  	self.content = file.read
  end


  def process
    load
    return false unless save
    require 'csv'
    Upload.transaction do #wrap in transaction
      CSV.parse(content, 
        :headers => true,
        :col_sep => "\t",      
        :header_converters => :symbol,
      ).each do |row|
        merch = Merchant.find_or_create_by_name_and_address!(name: row[:merchant_name], address: row[:merchant_address])
        buyer = Purchaser.find_or_create_by_name!(name: row[:purchaser_name])
        item = Item.find_or_create_by_description_and_merchant_id!(description: row[:item_description], price: row[:item_price], merchant_id: merch.id)
        Order.create!(quantity: row[:purchase_count], upload_id: id, item_id: item.id, purchaser_id: buyer.id)
      end
    end   
  end

  def revenue
    total = 0
    orders.each { |order| total += order.revenue}
    total
  end

  def verify_file_format
    return if content.nil? || content.empty?

    header = content.split("\n").first
    headers = header.split("\t")
    unless (headers & ["purchaser name", "item description", "item price", "purchase count", "merchant address", "merchant name"]).count == 6
      errors.add(:content, "#{filename} invalid .tab format")
    end
  end
end
