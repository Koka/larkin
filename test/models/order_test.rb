require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "order date parsed on save" do
    order = Order.new(delivery_date: '09/01/2014')
    assert_nil order.parsed_delivery_date
    order.save()
    assert_equal order.parsed_delivery_date, Date.parse('2014-09-01')
  end
end
