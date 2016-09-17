require 'test_helper'

class RoutelistsControllerTest < ActionDispatch::IntegrationTest
  test "should not allow unauthorized user" do
    get routelists_url
    assert_response 401
  end

  test "list should return all routelists for dispatcher" do
    get routelists_url, headers: authenticate(users(:three))
    assert_response :success

    list = JSON.parse(@response.body)["routelists"]
    assert_equal 1, list.size
    assert_equal orders(:three).id, list[0]['id']
  end

  test "list shouldn't return another user routelists for driver" do
    get routelists_url, headers: authenticate(users(:one))
    assert_response :success

    list = JSON.parse(@response.body)["routelists"]
    assert_equal 0, list.size
  end

  test "list should return routelists for driver" do
    get routelists_url, headers: authenticate(users(:four))
    assert_response :success

    list = JSON.parse(@response.body)["routelists"]
    assert_equal 1, list.size
  end

  test "show shouldn't return not owned truck routelist for driver" do
    assert_raises(Exception) {
      get routelist_url(orders(:three).id), headers: authenticate(users(:two))
    }
  end

  test "show should return owned truck routelist for driver" do
    get routelist_url(orders(:three).id), headers: authenticate(users(:four))
    routelist = JSON.parse(@response.body)["routelist"]
    assert_response :success
    assert_equal orders(:three).id, routelist["id"]
    assert_equal 3, routelist["stop_count"]
  end

  test "show should return owned truck routelist PDF for driver" do
    get routelist_url(orders(:three).id) + ".pdf", headers: authenticate(users(:four)).merge({"Accept" => "application/pdf"})
    assert_response :success
    assert_not_nil 0, @response.get_header('Content-Length')
    assert @response.get_header('Content-Type').start_with?('application/pdf')
  end

  test "show should return owned truck routelist stops for driver" do
    get stops_routelist_url(orders(:three).id), headers: authenticate(users(:four))
    list = JSON.parse(@response.body)["orders"]
    assert_response :success
    assert_equal 1, list.size
    assert_equal orders(:three).id, list[0]["id"]
  end
end
