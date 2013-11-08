require_relative "./helper"

describe "svn" do
  it "response should be an array" do
    VCR.use_cassette("svn/all_svnusers") do
      response = request "sites/devcloud:acquiatoolbeltdev/svnusers"
      expect(response.code).to eq "200"
      JSON.parse(response.body).should be_an_instance_of Array
    end
  end
end
