require "rspec"
require "net/https"
require "json"
require "multi_json"
require "cgi"
require "vcr"
require "netrc"
require "webmock"
require "acquia_toolbelt/cli/api"

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
