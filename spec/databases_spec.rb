require_relative "./helper"

describe "databases" do
  it "response should be an array" do
    VCR.use_cassette("database/all_databases") do
      response = request "sites/devcloud:acquiatoolbeltdev/dbs"
      expect(response.code).to eq "200"
      JSON.parse(response.body).should be_an_instance_of Array
    end
  end

  it "should return fields that are used" do
    VCR.use_cassette("database/all_databases") do
      response = request "sites/devcloud:acquiatoolbeltdev/dbs"
      expect(response.code).to eq "200"
      response.body.should include "name"
    end
  end
end
