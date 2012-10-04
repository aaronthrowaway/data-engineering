require 'spec_helper'

describe Upload do
	describe 'valid Upload file?' do
		it 'requires valid header' do
			subject.filename = "testfilename.csv"
			subject.content = "ipsum lorem"
			subject.should_not be_valid
		end

		it 'requires file contents' do
			subject.should_not be_valid
		end

		it 'requires valid filename' do	
			subject.should_not be_valid
		end
	end

	describe 'parse csv file:' do
		context 'Upload valid file' do
			before(:each) do
				@upload = Upload.new(filename: 'example_input.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'example_input.tab')))
				@upload.process
			end

			it "save Upload" do
				Upload.count.should == 1
			end

			it 'create valid purchasers' do
				purchasers = Purchaser.all
				purchasers.size.should == 3
				purchasers.first.name.should == "Snake Plissken"
			end

			it 'created necessary items' do
				items = Item.all
				items.size.should == 3
				items.first.description.should == "$10 off $20 of food"
				items.first.price.should == 10
				items.last.description.should == "$20 Sneakers for $5"
				items.last.price.should == 5
			end

			it 'adds new order data' do
				orders = Order.all
				orders.size.should == 4
				orders.first.quantity.should == 2
				orders.first.item_id.should_not be_nil
				orders.first.purchaser_id.should_not be_nil
				orders.first.upload_id.should_not be_nil
			end

			it 'creates required merchants' do
				merchants = Merchant.all
				merchants.size.should == 3
				merchants.first.address.should == "987 Fake St"
				merchants.first.name.should == "Bob's Pizza"
			end
			
		end

		context 'Upload invalid file' do
			before(:each) do
				@upload = Upload.new(filename: 'badinput.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'badinput.tab')))
				@upload.process
			end

			it 'should not Upload' do
				Upload.count.should == 0
			end

			it "should not have saved any other data" do
			 	Merchant.count.should == 0
				Item.count.should == 0
				Purchaser.count.should == 0
				Order.count.should == 0
			end
		end

		context 'Upload file with no data' do
			before(:each) do
				@upload = Upload.new(filename: 'valid_empty_file.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'empty_file.tab')))
				@upload.process
			end

			it "save Upload" do
				Upload.count.should == 0
			end

			it "should not have saved any other data" do
				Merchant.count.should == 0
				Item.count.should == 0
				Purchaser.count.should == 0
				Order.count.should == 0
			end
		end

		context 'test duplicate/invalid models' do
			before(:each) do
				@upload = Upload.new(filename: 'example_input.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'example_input.tab')))
				@upload.process
			end

			it "duplicate merchants aren't created" do
				Merchant.count.should == 3
				@upload.process
				Merchant.count.should == 3
			end

			it "duplicate purchasers aren't created if they have the same name" do
				Purchaser.count.should == 3
				@upload.process
				Purchaser.count.should == 3
			end

			it "duplicate items aren't created if they have the same name/merchant" do
				Item.count.should == 3
				@upload.process
				Item.count.should == 3
			end
		end
	end

	describe 'test revenue' do
		it 'calculate correct revenues' do
			@upload = Upload.new(filename: 'example_input.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'example_input.tab')))
			@upload.process
			@upload.revenue.should == 95.0
		end

		it '0 when there are no items present' do
			@upload = Upload.new(filename: 'valid_empty_file.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'empty_file.tab')))
			@upload.process
			@upload.revenue.should == 0
		end

		it '0 for malformed file' do
			@upload = Upload.new(filename: 'badinput.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'badinput.tab')))
			@upload.process
			@upload.revenue.should == 0
		end
	end
end