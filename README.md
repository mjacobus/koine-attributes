# Koine::Attributes

Strong attributes for ruby ruby objects.

Yes, there are [so many alternative solutions already](#alternative-solutions)! Why then? Cause some times people need distractions at the airports.

[![Build Status](https://travis-ci.org/mjacobus/koine-attributes.svg?branch=master)](https://travis-ci.org/mjacobus/koine-attributes)
[![Coverage Status](https://coveralls.io/repos/github/mjacobus/koine-attributes/badge.svg?branch=master)](https://coveralls.io/github/mjacobus/koine-attributes?branch=master)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/mjacobus/koine-attributes/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/mjacobus/koine-attributes/?branch=master)
[![Code Climate](https://codeclimate.com/github/mjacobus/koine-attributes/badges/gpa.svg)](https://codeclimate.com/github/mjacobus/koine-attributes)
[![Issue Count](https://codeclimate.com/github/mjacobus/koine-attributes/badges/issue_count.svg)](https://codeclimate.com/github/mjacobus/koine-attributes)

[![Gem Version](https://badge.fury.io/rb/koine-attributes.svg)](https://badge.fury.io/rb/koine-attributes)
[![Dependency Status](https://gemnasium.com/badges/github.com/mjacobus/koine-attributes.svg)](https://gemnasium.com/github.com/mjacobus/koine-attributes)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'koine-attributes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install koine-attributes

## Usage

 ```ruby
 class Person
   include Koine::Attributes

   attributes do
     attribute :name, :string
     attribute :birthday, :date

     # or
     attribute :birthday, Koine::Attributes::Adapter::Date.new
   end
 end

 peson = Person.new
 person.name = 'John Doe'
 person.birtday = '2001-02-31' # Date Object can also be given

 person.name # => 'John Doe'
 person.birthday # => #<Date 2001-02-31>

 person.attributes.to_h   # => {
                          #   name: 'John Doe',
                          #   birthday: #<Date 2001-02-31>
                          # }
 ```

Options:

 ```ruby
 attributes do
   attribute :name, Koine::Attributes::Adapters::Date.new.with_default_value('guest')

   # or
   attribute :name, :string, ->(adapter) { adapter.with_default_value('guest') }
 end
```

 Also, a constructor can be created by the API

 ```ruby
 class Person
   include Koine::Attributes

   attributes initializer: true do
     attribute :name, :string
     attribute :birthday, :date
   end
 end

 person = Person.new(name: 'John Doe', birthday: '2001-01-31')

 foo: attribute will raise error
 person = Person.new(name: 'John Doe', birthday: '2001-01-31', foo: :bar)
 ```

 You can disable strict mode

 ```ruby
 class Person
   include Koine::Attributes

   attributes initializer: { strict: false } do
     attribute :name, :string
     attribute :birthday, :date
   end
 end

 # foo will be ignored
 person = Person.new(name: 'John Doe', birthday: '2001-01-31', foo: :bar)
 ```

```ruby
class Product
  include Koine::Attributes

  attributes do
    attribute :price, MyCustom::Money.new
    attribute :available, :boolean, ->(attribues){ attributes.with_default_value(true) }
    attribute :available, Koine::Attributes::Drivers::Boolean.new.with_default_value(true)
  end
end

product = Product.new

product.available #  => true
product.available = 0
product.available #  => false

product.price = { currency: 'USD', value: 100 }

# or
product.price = "100 USD"
```

```ruby
class MyCustom::Money
  def default_value
    return 'some default_value'
  end

  def coerce(*values)
    Money.new(values.first, values.last)
  end
end

product = Product.new

product.available #  => true
product.available = 0
product.available #  => false

product.price = { currency: 'USD', value: 100 }

# or
product.price = "100 USD"
```

### Value objects

```ruby
class Location
  include Koine::Attributes

  attributes initializer: { freeze: true } do
    attribute :lat, :float
    attribute :lon, :float
  end
end

location = Location.new(lat: 1, lon: 2)
new_location = location.with_lon(3)
```

### Standard types

```ruby
:boolean, ->(adapter) { adapter.append_true_value('yes').append_false_value('no') }
:date
:float
:integer
:string
:time
```

### Alternative solutions

- [attributed_object](https://github.com/jgroeneveld/attributed_object)
- [virtus](https://github.com/solnic/virtus)
- [dry-struct](https://github.com/dry-rb/dry-struct)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mjacobus/koine-attributes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

