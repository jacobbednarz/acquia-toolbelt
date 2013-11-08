require_relative "./helper"

describe "ssh" do
  it "response should be an array" do
    VCR.use_cassette("ssh/all_sshkeys") do
      response = request "sites/devcloud:acquiatoolbeltdev/sshkeys"
      expect(response.code).to eq "200"
      JSON.parse(response.body).should be_an_instance_of Array
    end
  end
end
