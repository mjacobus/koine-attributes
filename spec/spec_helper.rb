if ENV['COVERALLS']
  require "coveralls"
  Coveralls.wear!
end

if ENV['COVERAGE']
  require "simplecov"

  SimpleCov.start
end

require "bundler/setup"
require "koine/attributes"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
