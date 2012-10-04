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
		end

		context 'Upload invalid file' do
			before(:each) do
				@upload = Upload.new(filename: 'badinput.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'badinput.tab')))
				@upload.process
			end

			it 'should not Upload' do
				Upload.count.should == 0
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
		end

		context 'test duplicate/invalid models' do
			before(:each) do
				@upload = Upload.new(filename: 'example_input.tab', content: IO.read(Rails.root.join('spec', 'fixtures', 'example_input.tab')))
				@upload.process
			end
		end
	end

	describe 'test revenue calculation:' do
	end
end