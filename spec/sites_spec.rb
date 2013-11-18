require_relative "./helper"

describe "sites" do
  it "response should be an array" do
    VCR.use_cassette("sites/all_sites") do
      response = AcquiaToolbelt::CLI::API.request "sites", "GET", {}, false
      expect(response.status).to eq 200
      JSON.parse(response.body).should be_an_instance_of Array
    end
  end

  it "should contain a valid sunscription name" do
    VCR.use_cassette("sites/all_sites") do
      response = AcquiaToolbelt::CLI::API.request "sites", "GET", {}, false
      expect(response.status).to eq 200
      response.body.should include "prod:eeamalone"
    end
  end
end
