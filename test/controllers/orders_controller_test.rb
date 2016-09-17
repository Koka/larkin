require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should not allow unauthorized user" do
    get orders_url
    assert_response 401
  end

  test "should not get for driver" do
    assert_raises(Exception) {
      get orders_url, headers: authenticate(users(:one))
    }
  end

  test "should get order list in reverse chronological order" do
    get orders_url, headers: authenticate(users(:three))
    assert_response :success

    list = JSON.parse(@response.body)["orders"]
    assert_equal 3, list.size
    assert_equal orders(:three).purchase_order_number, list[0]['purchase_order_number']
    assert_equal orders(:one).purchase_order_number, list[2]['purchase_order_number']
  end

  test "should show order by id" do
    get order_url(orders(:two).id), headers: authenticate(users(:three))
    assert_response :success

    order = JSON.parse(@response.body)["order"]
    assert_equal orders(:two).purchase_order_number, order['purchase_order_number']
  end

  test "should update order by id" do
    put order_url(orders(:two).id), headers: authenticate(users(:three)), params: {
      "order" => {
        "purchase_order_number" => 5
      }
    }
    assert_response :success

    order = JSON.parse(@response.body)["order"]
    assert_equal "5", order['purchase_order_number']

    get order_url(orders(:two).id), headers: authenticate(users(:three))
    assert_response :success

    order = JSON.parse(@response.body)["order"]
    assert_equal "5", order['purchase_order_number']
  end

  test "should split order by id" do
    post split_order_url(orders(:two).id), headers: authenticate(users(:three))
    assert_response :success

    found = Order.where(purchase_order_number: 2)
    assert_equal 2, found.size
    assert_equal 5, found[0].volume.to_i
    assert_equal 5, found[1].volume.to_i
    assert_equal 5, found[0].handling_unit_quantity.to_i
    assert_equal 5, found[1].handling_unit_quantity.to_i
  end

  test "should schedule orders preserving order" do
    post schedule_orders_url, headers: authenticate(users(:three)), params: {
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
    post schedule_orders_url, headers: authenticate(users(:three)), params: {
      truck: trucks(:one).id,
      shift: 'M',
      date: '2016-01-01',
      orders: [orders(:one).id, orders(:two).id, orders(:three).id]
    }
    assert_response :success

    post move_up_order_url(orders(:one)), headers: authenticate(users(:three))
    assert_response :success

    post move_down_order_url(orders(:three)), headers: authenticate(users(:three))
    assert_response :success

    post move_up_order_url(orders(:three)), headers: authenticate(users(:three))
    assert_response :success

    post move_down_order_url(orders(:one)), headers: authenticate(users(:three))
    assert_response :success

    o1 = Order.find orders(:one).id
    assert_equal trucks(:one).id, o1.load_truck_id
    assert_equal 'M', o1.load_shift
    assert_equal Date.parse('2016-01-01'), o1.load_date
    assert_equal 1, o1.load_ordinal

    o2 = Order.find orders(:two).id
    assert_equal trucks(:one).id, o2.load_truck_id
    assert_equal 'M', o2.load_shift
    assert_equal Date.parse('2016-01-01'), o2.load_date
    assert_equal 2, o2.load_ordinal

    o3 = Order.find orders(:three).id
    assert_equal trucks(:one).id, o3.load_truck_id
    assert_equal 'M', o3.load_shift
    assert_equal Date.parse('2016-01-01'), o3.load_date
    assert_equal 0, o3.load_ordinal
  end

  test "should upload orders CSV" do
    file = File.join(ActionDispatch::IntegrationTest.fixture_path, 'files/test_orders.csv')
    upload = fixture_file_upload(file, 'text/csv')
    post upload_orders_url, params: { file: upload }, headers: authenticate(users(:three)).merge("Content-Type" => 'text/csv')
    assert_response :success

    assert_equal 404, Order.count(:id)

    correct = {
      "delivery_date" => "9/23/2014",
      "delivery_shift" => nil,
      "origin_name" => "Larkin LLC",
      "origin_address" => "1505 S BLOUNT ST",
      "origin_city" => "RALEIGH",
      "origin_state" => "NC",
      "origin_zip" => "27603",
      "origin_country" => "US",
      "client_name" => "Stephania Dietrich",
      "destination_address" => "728 BENT CREEK DRIVE",
      "destination_city" => "HOPE MILLS",
      "destination_state" => "NC",
      "destination_zip" => "28348",
      "destination_country" => "US",
      "phone_number" => "1-250-615-3875 x1092",
      "mode" => "TRUCKLOAD",
      "purchase_order_number" => "500397590",
      "volume" => "64.8",
      "handling_unit_quantity" => "3",
      "handling_unit_type" => "box",
      "parsed_delivery_date" => Date.parse("2014-09-23"),
      "load_truck_id" => nil,
      "load_shift" => nil,
      "load_date" => nil,
      "load_ordinal" => nil,
      "cancelled" => nil
    }

    order = Order.find_by(purchase_order_number: '500397590').attributes

    correct["id"] = order["id"]
    correct["updated_at"] = order["updated_at"]
    correct["created_at"] = order["created_at"]

    assert_equal correct, order
  end
end
