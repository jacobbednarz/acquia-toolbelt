require_relative "./helper"

describe "servers" do
  it "response should be an array" do
    VCR.use_cassette("servers/all_dev_servers") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/servers", "GET", {}, false
      expect(response.status).to eq 200
      JSON.parse(response.body).should be_an_instance_of Array
    end
  end

  it "should return basic server fields" do
    VCR.use_cassette("servers/all_dev_servers") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/servers", "GET", {}, false
      expect(response.status).to eq 200
      response.body.should include("ec2_availability_zone", "name", "fqdn", "ami_type", "ec2_region", "services")
    end
  end

  it "should return varnish instance fields" do
    VCR.use_cassette("servers/all_dev_servers") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/servers", "GET", {}, false
      expect(response.status).to eq 200
      response.body.should include("varnish", "status")
    end
  end

  it "should return web server fields" do
    VCR.use_cassette("servers/all_dev_servers") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/servers", "GET", {}, false
      expect(response.status).to eq 200
      response.body.should include("web", "status", "php_max_procs")
    end
  end

  it "should return database instance fields" do
    VCR.use_cassette("servers/all_dev_servers") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/servers", "GET", {}, false
      expect(response.status).to eq 200
      response.body.should include "database"
    end
  end

  it "should return vcs instance fields" do
    VCR.use_cassette("servers/all_dev_servers") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/servers", "GET", {}, false
      expect(response.status).to eq 200
      response.body.should include "vcs", "vcs_url", "vcs_type", "vcs_path"
    end
  end
end
