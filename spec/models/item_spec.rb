require 'spec_helper'

describe Item do
	it 'merchant validations' do
		merchant = Item.create
		merchant.should have(1).error_on(:price)
		merchant.should have(1).error_on(:merchant_id)
		merchant.should have(1).error_on(:description)
	end
end
