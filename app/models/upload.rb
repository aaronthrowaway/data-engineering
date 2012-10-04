require 'csv'
class Upload < ActiveRecord::Base
  attr_accessible :content, 
                  :filename, 
                  :file

 	attr_accessor   :file

  validates_presence_of :filename
  validates_presence_of :content
  validate :verify_file_format

  def load
  	return if file.nil?
  	self.filename = file.original_filename
  	self.content = file.read
  end


  def process
    load
    return false unless save
    
    Upload.transaction do #wrap in transaction
      CSV.parse(content, 
        :headers => true,
        :col_sep => "\t",      
        :header_converters => :symbol,
      ).each do |row|
      end
    end   
  end

  def revenue
    10.00
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
