require 'test_helper'

class PaperTest < ActiveSupport::TestCase



	test "save_paper" do
		paper=papers(:one)
		paper_new=Paper.new(:filename =>'new.docx', :author => paper.author)
		assert paper_new.save!, 'paper save worked'
	end

end
