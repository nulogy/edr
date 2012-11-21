require 'spec_helper'
require_relative '../test_data'

describe Edr::AR::DataValidator do

  describe "Using data validation for a saved model" do
    example do
      order_data = OrderData.create! amount: 10, deliver_at: Date.today
      order = Order.build(order_data)
      order.amount = "blah"
      Edr::AR::DataValidator.validate(order).should be_present
    end
  end

  describe "Using data validation for a new model" do
    example do
      order = Order.build(amount: "blah")
      Edr::AR::DataValidator.validate(order).should be_present
    end
  end
end
