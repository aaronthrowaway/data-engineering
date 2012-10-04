require 'csv'
class Upload < ActiveRecord::Base
  attr_accessible :content, :filename, :file
  attr_accessor :file

  validates :filename, :presence => true
  validates :content, :presence => true
  validate :verify_file_format

  def load
  	return if file.nil?
  	self.filename = file.original_filename
  	self.content = file.read
  end


  def process
    load
    return false unless save
      CSV.parse(content, 
        :headers => true,
        :col_sep => "\t",      
        :header_converters => :symbol,
      ).each do |row|
      end
  end

  def revenue
  end

  def verify_file_format
    return if content.nil? || content.empty?

    header = content.split("\n").first
    headers = header.split("\t")
    unless (headers & ["purchaser name", "item description", "item price", "purchase count", "merchant address", "merchant name"]).count == 6
      #check for array intersection for required headers. if intersection is not all 6 headers, something is invalid
      errors.add(:content, "#{filename} has invalid/missing/too many headers.")
    end
  end
end
