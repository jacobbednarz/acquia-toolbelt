require "rspec"
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
#
# Returns a
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
#
# Returns a boolean.
def is_netrc?
  true
end

# Internal: Check if the database is already assigned to a subscription.
#
# Returns boolean.
def database_exist?(database)
  databases = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/dbs", "GET"
  databases.each do |d|
    d.include? database
  end
end

# Internal: Check if the domain is already assigned to a subscription.
#
# Returns boolean.
def domain_exist?(domain)
  domains = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/domains", "GET"
  domains.each do |d|
    d.include? domain
  end
end

# Internal: Generate a unique database name.
#
# This allows custom and unique databases to be generated without conflicting with
# existing databases.
#
# Returns a string of the database.
def generate_unique_database_name
  "test-suite-db-#{8.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join}"
end

# Internal: Generate a unique domains name.
#
# This allows custom and unique domains to be generated without conflicting with
# existing domains.
#
# Returns a string of the domain.
def generate_unique_domain_name
  "test-suite-domain-#{8.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join}.com"
end

# Internal: Search an array for a match to the test suite databases.
#
# Returns an existing database name.
def use_existing_database
  VCR.use_cassette("databases/get_all_existing_databases") do
    databases = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/dbs"
    databases.select { |db| db["name"] =~ /test-suite-db-*/ }.sample["name"]
  end
end

# Internal: Search an array for a match to the test suite domains.
#
# Returns an existing domain name.
def use_existing_domain
  VCR.use_cassette("domains/get_all_existing_domains") do
    domains = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/domains"
    domains.select { |db| db["name"] =~ /test-suite-domain-*/ }.sample["name"]
  end
end
