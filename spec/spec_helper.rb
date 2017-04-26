if ENV['COVERALLS']
  require 'coveralls'
  Coveralls.wear!
end

if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start
end

require 'bundler/setup'
require 'koine/attributes'
require 'date'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class CustomDumbAdapter
  attr_reader :default_value, :append

  def initialize(default_value: 'default value', append: 'coerced')
    @default_value = default_value
    @append = append
  end

  def coerce(*values)
    value = values.first
    "#{value}-#{append}"
  end
end

class DumbAdapter < CustomDumbAdapter
  def initialize
    super(default_value: 'default-value', append: 'coerced')
  end
end

class ExampleClass
  include Koine::Attributes

  attributes do
    attribute :name, CustomDumbAdapter.new
    attribute :last_name, CustomDumbAdapter.new(
      default_value: 'default last name',
      append: 'last'
    )
  end
end

class ExampleClassWithConstructor
  include Koine::Attributes

  attributes initializer: { strict: false } do
    attribute :name, DumbAdapter.new
    attribute :last_name, DumbAdapter.new
    attribute :last_name, CustomDumbAdapter.new(append: 'last')
  end
end

class ExampleClassWithStrictConstructor
  include Koine::Attributes

  attributes initializer: true do
    attribute :name, DumbAdapter.new
    attribute :last_name, CustomDumbAdapter.new(append: 'last')
  end
end

class ExampleWithDate
  include Koine::Attributes

  attributes initializer: true do
    attribute :date_with_object, Koine::Attributes::Adapter::Date.new.with_default_value('default_date')
    attribute :date_with_symbol, :date
    attribute :date_with_block_constructor, :date do |adapter|
      adapter.with_default_value { Date.today }
    end

    attribute :date_with_lambda_constructor, :date, ->(adapter) {
      adapter.with_default_value { Date.today }
    }
  end
end
