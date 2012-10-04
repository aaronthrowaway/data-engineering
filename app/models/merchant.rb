class Merchant < ActiveRecord::Base
  attr_accessible :address, 
									:name

	validates_presence_of :name
	validates_presence_of :address

	has_many :items
end
