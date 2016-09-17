require 'test_helper'

class TrucksControllerTest < ActionDispatch::IntegrationTest
  test "should not allow unauthorized user" do
    get trucks_url
    assert_response 401
  end

  test "list should return all trucks for dispatcher sorted by id" do
    get trucks_url, headers: authenticate(users(:three))
    assert_response :success

    list = JSON.parse(@response.body)["trucks"]
    assert_equal 3, list.size
    assert_operator list[0]['id'], :<, list[1]['id']
  end

  test "list should return only one truck when accessed by driver" do
    get trucks_url, headers: authenticate(users(:two))
    assert_response :success

    list = JSON.parse(@response.body)["trucks"]
    assert_equal 1, list.size
    assert_equal list[0]['id'], trucks(:two).id
  end

  test "show should return truck for dispatcher" do
    get truck_url( trucks(:one).id ), headers: authenticate(users(:three))
    assert_response :success

    truck = JSON.parse(@response.body)["truck"]
    assert_equal truck['id'], trucks(:one).id
  end

  test "show should return only owned truck for dirver" do
    assert_raises(Exception) {
      get truck_url( trucks(:one).id ), headers: authenticate(users(:two))
    }
  end

  test "shifts should return only owned truck for dirver" do
    assert_raises(Exception) {
      get shift_available_truck_url( trucks(:one).id, 'M', '2015-01-01' ), headers: authenticate(users(:two))
    }
  end

  test "shifts should return if shift allowed for dispatcher" do
    get shift_available_truck_url( trucks(:one).id, 'M', '2015-01-01' ), headers: authenticate(users(:three))
    assert_response :success

    assert_equal 'false', @response.body
  end

  test "shifts should return if shift allowed for drivers owned truck" do
    get shift_available_truck_url( trucks(:one).id, 'M', '2015-01-01' ), headers: authenticate(users(:one))
    assert_response :success

    assert_equal 'false', @response.body
  end

  test "shifts should interleave in 2 dimensions" do
    get shift_available_truck_url( trucks(:one).id, 'M', '2015-01-01' ), headers: authenticate(users(:one))
    assert_response :success
    assert_equal 'false', @response.body

    get shift_available_truck_url( trucks(:one).id, 'N', '2015-01-01' ), headers: authenticate(users(:one))
    assert_response :success
    assert_equal 'true', @response.body

    get shift_available_truck_url( trucks(:one).id, 'E', '2015-01-01' ), headers: authenticate(users(:one))
    assert_response :success
    assert_equal 'false', @response.body

    get shift_available_truck_url( trucks(:two).id, 'M', '2015-01-01' ), headers: authenticate(users(:two))
    assert_response :success
    assert_equal 'true', @response.body

    get shift_available_truck_url( trucks(:two).id, 'N', '2015-01-01' ), headers: authenticate(users(:two))
    assert_response :success
    assert_equal 'false', @response.body

    get shift_available_truck_url( trucks(:two).id, 'E', '2015-01-01' ), headers: authenticate(users(:two))
    assert_response :success
    assert_equal 'true', @response.body

    get shift_available_truck_url( trucks(:one).id, 'M', '2015-01-02' ), headers: authenticate(users(:one))
    assert_response :success
    assert_equal 'true', @response.body

    get shift_available_truck_url( trucks(:one).id, 'N', '2015-01-02' ), headers: authenticate(users(:one))
    assert_response :success
    assert_equal 'false', @response.body

    get shift_available_truck_url( trucks(:one).id, 'E', '2015-01-02' ), headers: authenticate(users(:one))
    assert_response :success
    assert_equal 'true', @response.body

    get shift_available_truck_url( trucks(:two).id, 'M', '2015-01-02' ), headers: authenticate(users(:two))
    assert_response :success
    assert_equal 'false', @response.body

    get shift_available_truck_url( trucks(:two).id, 'N', '2015-01-02' ), headers: authenticate(users(:two))
    assert_response :success
    assert_equal 'true', @response.body

    get shift_available_truck_url( trucks(:two).id, 'E', '2015-01-02' ), headers: authenticate(users(:two))
    assert_response :success
    assert_equal 'false', @response.body
  end
end
