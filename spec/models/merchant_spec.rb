require 'spec_helper'

describe Merchant do
	it 'merchant validations' do
		merchant = Merchant.create
		merchant.should have(1).error_on(:name)
		merchant.should have(1).error_on(:address)
	end
end
