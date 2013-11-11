require_relative "./helper"

describe "svn" do
  it "response should be an array" do
    VCR.use_cassette("svn/all_svnusers") do
      response = AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/svnusers", "GET", {}, false
      expect(response.status).to eq 200
      JSON.parse(response.body).should be_an_instance_of Array
    end
  end
end
