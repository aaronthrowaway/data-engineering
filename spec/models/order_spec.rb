require 'spec_helper'

describe Order do
	describe 'test revenue' do
		before :each do
			item = Item.create(price: 4.00, description: "a", merchant_id: 0)
			@order = Order.create(item_id: item.id, quantity: 2)
		end

		it 'calculate correct revenues' do
			@order.revenue.should == 8
		end

		it '0 prices' do
			@order.item.price = 0
			@order.revenue.should == 0
		end

		it '0 when there are no items present' do
			@order.item = nil
			@order.revenue.should == 0
		end
	end

	describe 'validators' do
		it 'requires purchases have items, and customers' do
			order = Order.create
			order.should have(1).error_on(:quantity)
			order.should have(1).error_on(:upload_id)
			order.should have(1).error_on(:purchaser_id)
			order.should have(1).error_on(:item_id)
		end
	end
end
