require 'spec_helper'
require_relative '../test_data'

describe Edr::Repository do
  describe "Persisting objects" do
    example do
      order = Order.new amount: 10

      OrderRepository.persist order

      order.id.should be_present
      order.amount.should == 10
    end

    it "persists an aggregate with children" do
      order = Order.new amount: 10
      order.add_item name: 'item1', amount: 5

      OrderRepository.persist order

      from_db = OrderRepository.find(order.id)
      from_db.items.first.amount.should == 5
    end

    it "raises an exception when invalid data" do
      order = Order.new amount: "invalid"

      ->{OrderRepository.persist order}.should raise_error
    end
  end

  describe "Creating objects through the repository variable" do
    let(:order) do
      order = Order.new(amount: 10)
      OrderRepository.persist order
      order
    end

    example do
      order.add_item_through_repository name: 'item', amount: 10
      order.items.first.name.should == 'item'
    end

    it "raises an exception when the root is not persisted" do
      ->{Order.new(amount: 10).add_item_through_repository({})}.should raise_error
    end
  end

  describe "Selecting models" do
    let!(:data){OrderData.create! amount: 10, deliver_at: Date.today}

    example do
      orders = OrderRepository.find_by_amount 10
      orders.first.id == data.id
    end

    it "finds by id" do
      order = OrderRepository.find data.id
      order.id.should == data.id
    end

    it "returns all saved objects" do
      orders = OrderRepository.all
      orders.first.id == data.id
    end

    it "raises an exception when cannot find cannot find object" do
      ->{OrderRepository.find 999}.should raise_error
    end
  end

  describe "Deleting models" do
    let!(:order) do
      order = Order.new amount: 10, deliver_at: Date.today
      OrderRepository.persist order
      order
    end

    example do
      OrderRepository.delete order
      OrderRepository.find_by_id(order.id).should be_nil
    end

    it "deletes by id" do
      OrderRepository.delete_by_id order.id
      OrderRepository.find_by_id(order.id).should be_nil
    end

    it "raises an exception when cannot find cannot find object" do
      ->{OrderRepository.delete_by_id 999}.should raise_error
    end
  end
end