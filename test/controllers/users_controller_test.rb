require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should not get unauthorized user" do
    get user_url(users(:two).id)
    assert_response 401
  end

  test "should not get for driver" do
    assert_raises(Exception) {
      get user_url(users(:one).id), headers: authenticate(users(:one))
    }
  end

  test "should get for dispatcher" do
    get user_url(users(:one).id), headers: authenticate(users(:three))
    assert_response :success

    user = JSON.parse(@response.body)["user"]
    assert_equal 'user1', user["name"]
    assert_equal 'user1', user["login"]
    assert_equal 'driver', user["role"]
    assert_nil user["password"]
  end
end
