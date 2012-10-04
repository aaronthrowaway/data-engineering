require 'spec_helper'

describe Purchaser do
	it 'merchant validations' do
		merchant = Purchaser.create
		merchant.should have(1).error_on(:name)
	end
end
