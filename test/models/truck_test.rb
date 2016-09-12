require 'test_helper'

class TruckTest < ActiveSupport::TestCase
    test "retrieves driver relationship correctly" do
      assert_equal Truck.find(trucks(:one).id).driver, users(:one)
      assert_equal Truck.find(trucks(:two).id).driver, users(:two)
    end
end
