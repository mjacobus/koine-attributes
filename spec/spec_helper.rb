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

module SpecHelper
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def it_behaves_like_an_adapter
      it 'extends Base' do
        expect(subject).to be_a(Koine::Attributes::Adapter::Base)
      end
    end

    def it_wont_coerce(input)
      it "raises ArgumentError with #{input}" do
        expect { subject.coerce(input) }.to raise_error(ArgumentError)
      end
    end

    def it_coerces(input, options = {})
      output = options.fetch(:to)

      it "#coerce coerces #{input} (#{input.class}) into #{output} (#{output.class})" do
        coerced = subject.coerce(input)

        expect(coerced).to eq(output)

        expect(coerced).to be_frozen unless options[:skip_frozen]
        expect(coerced).not_to be(subject.coerce(input)) unless options[:skip_dup]
      end
    end
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'
  config.include SpecHelper

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
