require_relative "./helper"

describe "files" do
  it "should copy files from dev to stage environment" do
    VCR.use_cassette("files/copy_from_dev_to_stage") do
      response = AcquiaToolbelt::CLI::API.request "sites/prod:eeamalone/files-copy/dev/test", "POST", {}, false
      expect(response.status).to eq 200
      response.body.should include "id"
    end
  end
end
