require_relative "./helper"

describe "sites" do
  it "response should be an array" do
    VCR.use_cassette("sites/all_sites") do
      response = request "sites"
      expect(response.code).to eq "200"
      JSON.parse(response.body).should be_an_instance_of Array
    end
  end

  it "should contain required fields" do
    VCR.use_cassette("sites/all_sites") do
      response = request "sites"
      expect(response.code).to eq "200"
      response.body.should include "devcloud:acquiatoolbeltdev"
    end
  end
end
