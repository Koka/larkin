require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should not allow unauthorized user" do
    get orders_list_url
    assert_response 401
  end

  test "should not get for driver" do
    assert_raises(Exception) {
      get orders_list_url, headers: authenticate(users(:one))
    }
  end

  test "should get order list in reverse chronological order" do
    get orders_list_url, headers: authenticate(users(:three))
    assert_response :success

    list = JSON.parse(@response.body)["orders"]
    assert_equal 3, list.size
    assert_equal orders(:three).purchase_order_number, list[0]['purchase_order_number']
    assert_equal orders(:one).purchase_order_number, list[2]['purchase_order_number']
  end

  test "should show order by id" do
    get orders_show_url(orders(:two).id), headers: authenticate(users(:three))
    assert_response :success

    order = JSON.parse(@response.body)["order"]
    assert_equal orders(:two).purchase_order_number, order['purchase_order_number']
  end

  test "should update order by id" do
    put orders_update_url(orders(:two).id), headers: authenticate(users(:three)), params: {
      "order" => {
        "purchase_order_number" => 5
      }
    }
    assert_response :success

    order = JSON.parse(@response.body)["order"]
    assert_equal "5", order['purchase_order_number']

    get orders_show_url(orders(:two).id), headers: authenticate(users(:three))
    assert_response :success

    order = JSON.parse(@response.body)["order"]
    assert_equal "5", order['purchase_order_number']
  end

  test "should split order by id" do
    post orders_split_url(orders(:two).id), headers: authenticate(users(:three))
    assert_response :success

    found = Order.where(purchase_order_number: 2)
    assert_equal 2, found.size
    assert_equal 5, found[0].volume.to_i
    assert_equal 5, found[1].volume.to_i
    assert_equal 5, found[0].handling_unit_quantity.to_i
    assert_equal 5, found[1].handling_unit_quantity.to_i
  end

  test "should schedule orders preserving order" do
    post orders_schedule_url, headers: authenticate(users(:three)), params: {
      truck: trucks(:one).id,
      shift: 'M',
      date: '2016-01-01',
      orders: [orders(:one).id, orders(:two).id, orders(:three).id]
    }
    assert_response :success

    o1 = Order.find orders(:one).id
    assert_equal trucks(:one).id, o1.load_truck_id
    assert_equal 'M', o1.load_shift
    assert_equal Date.parse('2016-01-01'), o1.load_date
    assert_equal 0, o1.load_ordinal

    o2 = Order.find orders(:two).id
    assert_equal trucks(:one).id, o2.load_truck_id
    assert_equal 'M', o2.load_shift
    assert_equal Date.parse('2016-01-01'), o2.load_date
    assert_equal 1, o2.load_ordinal

    o3 = Order.find orders(:three).id
    assert_equal trucks(:one).id, o3.load_truck_id
    assert_equal 'M', o3.load_shift
    assert_equal Date.parse('2016-01-01'), o3.load_date
    assert_equal 2, o3.load_ordinal
  end

  test "should move scheduled orders" do
    post orders_schedule_url, headers: authenticate(users(:three)), params: {
      truck: trucks(:one).id,
      shift: 'M',
      date: '2016-01-01',
      orders: [orders(:one).id, orders(:two).id, orders(:three).id]
    }
    assert_response :success

    post orders_move_up_url(orders(:three)), headers: authenticate(users(:three))
    assert_response :success

    post orders_move_down_url(orders(:one)), headers: authenticate(users(:three))
    assert_response :success

    o1 = Order.find orders(:one).id
    assert_equal trucks(:one).id, o1.load_truck_id
    assert_equal 'M', o1.load_shift
    assert_equal Date.parse('2016-01-01'), o1.load_date
    assert_equal 2, o1.load_ordinal

    o2 = Order.find orders(:two).id
    assert_equal trucks(:one).id, o2.load_truck_id
    assert_equal 'M', o2.load_shift
    assert_equal Date.parse('2016-01-01'), o2.load_date
    assert_equal 1, o2.load_ordinal

    o3 = Order.find orders(:three).id
    assert_equal trucks(:one).id, o3.load_truck_id
    assert_equal 'M', o3.load_shift
    assert_equal Date.parse('2016-01-01'), o3.load_date
    assert_equal 0, o3.load_ordinal
  end

  test "should upload orders CSV" do
    post orders_upload_url, headers: authenticate(users(:three))
    #TODO: test me
    assert_response :success
  end
end
