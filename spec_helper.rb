require "minitest/autorun"
require "minitest/spec"
require "net/https"
require "json"
require "multi_json"
require "cgi"
require "vcr"
require "netrc"
require "webmock"

n = Netrc.read
@acquia_username, @acquia_password = n["cloudapi.acquia.com"]

VCR.configure do |c|
  c.filter_sensitive_data("<ACQUIA_USERNAME>") do
    CGI.escape @acquia_username
  end
  c.filter_sensitive_data("<ACQUIA_PASSWORD>") do
    CGI.escape @acquia_password
  end

  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.default_cassette_options = {
    :serialize_with => :json,
  }
end

# Thanks to minitest not having a built in way for running all tests at once,
# here is my solution to run them all.
Dir.glob("./spec/**/*_spec.rb").each { |file| require file }
