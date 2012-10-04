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

			it 'create valid customers' do
				# customers = Customer.all
				# customers.size.should == 3
				# customers.first.name.should == "Snake Plissken"
			end

			it 'created necessary items' do
				# items = Item.all
				# items.size.should == 3
				# items.first.description.should == "$10 off $20 of food"
				# items.first.price.should == 10
				# items.last.description.should == "$20 Sneakers for $5"
				# items.last.price.should == 5
			end

			it 'adds new purchase data' do
				# purchases = Purchase.all
				# purchases.size.should == 4
				# purchases.first.count.should == 2
				# purchases.first.item_id.should_not be_nil
				# purchases.first.customer_id.should_not be_nil
				# purchases.first.Upload_id.should_not be_nil
			end

			it 'creates required merchants' do
				# merchants = Merchant.all
				# merchants.size.should == 3
				# merchants.first.address.should == "987 Fake St"
				# merchants.first.name.should == "Bob's Pizza"
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
				# Merchant.count.should == 0
				# Item.count.should == 0
				# Customer.count.should == 0
				# Purchase.count.should == 0
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
				# Merchant.count.should == 0
				# Item.count.should == 0
				# Customer.count.should == 0
				# Purchase.count.should == 0
			end
		end

		context 'test duplicate/invalid models' do
			before(:each) do
				@upload = Upload.new(filename: 'example_input.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'example_input.tab')))
				@upload.process
			end

			it "duplicate merchants aren't created if they have the same name" do
				# Merchant.count.should == 3
				# @Upload.Upload
				# Merchant.count.should == 3
			end

			it "duplicate customers aren't created if they have the same name" do
				# Customer.count.should == 3
				# @Upload.Upload
				# Customer.count.should == 3
			end

			it "duplicate items aren't created if they have the same name/merchant" do
				# Item.count.should == 3
				# @Upload.Upload
				# Item.count.should == 3
			end
		end
	end

	describe 'test revenue calculation:' do
		it 'calculate correct revenue by adding up all purchase costs' do
			# @Upload = Upload.new(filename: 'example_input.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'example_input.tab')))
			# @Upload.process
			# @Upload.total_price.should == 95.0
		end

		# it 'finds 0 when there are no items present' do
		# 	@Upload = Upload.new(filename: 'valid_empty_file.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'empty_file.tab')))
		# 	@Upload.Upload
		# 	@Upload.total_price.should == 0
		# end

		# it 'should return 0 for malformed file' do
		# 	@Upload = Upload.new(filename: 'badinput.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'badinput.tab')))
		# 	@Upload.Upload
		# 	@Upload.total_price.should == 0
		# end
	end
end