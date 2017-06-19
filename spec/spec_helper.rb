require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start

# preload default protocol version FIX4.4
require 'fix/protocol'

RSpec.configure do |config|
  config.mock_with :rspec
end
