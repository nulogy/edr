require 'spec_helper'
require_relative '../test_data'

describe Edr::Model do

  describe "Using data objects directly" do
    example do
      order = OrderData.create! amount: 10, deliver_at: Date.today
      order.items.create! amount: 6, name: 'Item 1'
      order.items.create! amount: 4, name: 'Item 2'

      order.reload.items.size.should == 2
      order.items.first.amount.should == 6
    end
  end

  describe "Creating a new model object" do
    example do
      order = Order.new
      order.amount = 15

      order.amount.should == 15
    end

    it "uses hash to initialize fields" do
      order = Order.new amount: 15

      order.amount.should == 15
    end

    it "creating an aggregate with children" do
      order = Order.new
      item = order.add_item name: 'item1', amount: 10

      item.name.should == 'item1'
    end
  end

  describe "Using data structure instead of a data object" do
    example do
      order = Order.new OpenStruct.new
      order.amount = 99
      order.amount.should == 99
    end
  end
end