require 'minitest/autorun'
require 'minitest/spec'

# Thanks to minitest not having a built in way for running all tests at once,
# here is my solution to run them all.
Dir.glob('./spec/**/*_spec.rb').each { |file| require file}