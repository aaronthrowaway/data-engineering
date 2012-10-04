class Item < ActiveRecord::Base
  attr_accessible :description, 
  								:price, 
  								:merchant_id

  validates_presence_of :description
  validates_presence_of :price
  validates_presence_of :merchant_id

  has_one :merchant
end
