# Edr

[![Build Status](https://secure.travis-ci.org/elight/edr.png)](http://travis-ci.org/elight/edr)
[![Code Climate](https://codeclimate.com/github/elight/edr.png)](http://codeclimate.com/elight/edr)

Blog post describing EDR: ["Building Rich Domain Models in Rails. Separating Persistence"](http://engineering.nulogy.com/posts/building-rich-domain-models-in-rails-separating-persistence).

# Description

Originally named for "Entity, Data, Repository", building on the [Repository pattern](http://martinfowler.com/eaaCatalog/repository.html).

# Example

Lifted from <code>spec/test_data.rb</code>:

## STEP0: Schema
``` ruby
ActiveRecord::Schema.define(:version => 1) do
  create_table "orders", :force => true do |t|
    t.decimal  "amount"
    t.date     "deliver_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.decimal  "amount"
    t.integer  "order_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end
end
```

## STEP1: Define data objects
``` ruby
class OrderData < ActiveRecord::Base
  self.table_name = "orders"

  attr_accessible :amount, :deliver_at

  validates :amount, numericality: true
  has_many :items, class_name: 'ItemData', foreign_key: 'order_id'
end

class ItemData < ActiveRecord::Base
  self.table_name = "items"

  attr_accessible :amount, :name

  validates :amount, numericality: true
  validates :name, presence: true
end
```

## STEP2: Define Domain Model

Fields and associations on the Domain Model are determined via ActiveRecord reflection.  The Domain Model is coupled to its ActiveRecord class by naming convention.

Domain Model classes should share the same name as the AR classes except they should not end in "Data".  So OrderData < ActiveRecord::Base maps to the Order domain 
model class.

Be aware that your Domain Model test/specs will need to stub/mock out dependencies upon their Repository and other Domain Model objects.  That is, you Domain Model instances will lack fields or associations in their tests. This is because Domain Model objects are [POROs](http://blog.jayfields.com/2007/10/ruby-poro.html) until they are registered with edr at runtime.  As you should not want to test the framework, this should facilitate testing your Domain Model and your persistence in isolation from one another and from the edr framework.

``` ruby
class Order
  def add_item attrs
    repository.create_item self, attrs
  end
end

class Item
end
```

## STEP3: map data objects to domain objects

You probably want the below in a config/initializers/edr.rb

``` ruby
Edr::Registry.map_models_to_mappers
```


## STEP4: Define repository to access data

Your Repositories arbitrate persistence on behalf of the Domain Model.
While it is not ideal for the Domain Model to be aware of the Repository,
we're stuck with this unless we add a [Unit of Work] reification to
manage the relationship between the Domain Model and the Repository

``` ruby
module OrderRepository
  extend Edr::AR::Repository

  set_model_class Order

  def self.find_by_amount amount
    where(amount: amount)
  end

  def self.find_by_id id
    where(id: id).first
  end

  def self.create_item order, attrs
    item = ItemRepository.create_item(order, attrs)
    data(order).reload
    return item
  end
end

module ItemRepository
  extend Edr::AR::Repository
  set_model_class Item

  def self.create_item order, attrs
    item = Item.build(attrs)
    item.order_id = order.id
    persist item
  end
end
```


## Installation

Add this line to your application's Gemfile:

    gem 'edr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install edr

