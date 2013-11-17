require_relative "./helper"

describe "environments" do
  it "response should be an array" do
    VCR.use_cassette("environments/all_environments") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs", "GET", {}, false
      expect(response.status).to eq 200
      JSON.parse(response.body).should be_an_instance_of Array
    end
  end

  it "should return fields that are used" do
    VCR.use_cassette("environments/all_environments") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs", "GET", {}, false
      expect(response.status).to eq 200
      response.body.should include("name", "livedev", "ssh_host", "db_clusters", "vcs_path", "default_domain")
    end
  end

  it "should be able to enable live development mode" do
    VCR.use_cassette("environments/enable_live_development") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/livedev/enable", "POST", {}, false
      expect(response.status).to eq 200
      response.body.should include "id"
    end
  end

  it "should be able to disable live development mode" do
    VCR.use_cassette("environments/disable_live_development") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/envs/dev/livedev/disable", "POST", {}, false
      expect(response.status).to eq 200
      response.body.should include "id"
    end
  end
end
