require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "retrieves role correctly" do
    assert_equal :driver, User.find(users(:one).id).role
    assert_equal :driver, User.find(users(:two).id).role
    assert_equal :dispatcher, User.find(users(:three).id).role
  end
end
