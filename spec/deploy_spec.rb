require_relative "./helper"

describe "deploys" do
  it "should deploy a VCS branch to the dev environment" do
    VCR.use_cassette("deploy/release_vcs_branch") do
      data = { :key => "path", :value => "master" }
      response = AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/envs/dev/code-deploy", "QUERY-STRING-POST", data, false
      (response.status).should eq 200
      response.body.should include "id"
    end
  end
end
