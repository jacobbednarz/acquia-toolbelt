require "rspec"
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

# Internal: Determine what authentication method is available and load it.
def setup_authentication
  if is_netrc?
    n = Netrc.read
    @acquia_username, @acquia_password = n["cloudapi.acquia.com"]
  end
end

# Internal: Check if netrc is available for authentication.
#
# This currently returns true all the time as it is the only means of
# authentication.
def is_netrc?
  true
end

def request(resource)
  setup_authentication

  uri = URI("https://cloudapi.acquia.com/v1/#{resource}.json")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri.request_uri)
  request.basic_auth @acquia_username, @acquia_password

  response = http.request(request)
end
