require 'test_helper'
require 'helpers/auth'

class CurrentUserControllerTest < ActionDispatch::IntegrationTest
  test "should not get unauthorized user" do
    get me_users_url
    assert_response 401
  end

  test "should get authorized user" do
    get me_users_url, headers: authenticate(users(:one))
    assert_response :success

    user = JSON.parse(@response.body)["user"]
    assert_equal 'user1', user["name"]
    assert_equal 'user1', user["login"]
    assert_equal 'driver', user["role"]
    assert_nil user["password"]
  end

  test "should have dispatcher role if not driving anything" do
    get me_users_url, headers: authenticate(users(:three))
    assert_response :success

    user = JSON.parse(@response.body)["user"]
    assert_equal 'user3', user["name"]
    assert_equal 'user3', user["login"]
    assert_equal 'dispatcher', user["role"]
    assert_nil user["password"]
  end
end
