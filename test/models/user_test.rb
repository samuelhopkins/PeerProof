require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'save_user' do
  	user=User.new(:email => 'joe@sam.edu', :credits => 0, :password => 'samsamsam')
  	assert user.save!, 'user didnt save'
end
end
