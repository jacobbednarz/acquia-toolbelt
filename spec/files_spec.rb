require_relative "./helper"

describe "files" do
  it "should copy files from dev to stage environment" do
    VCR.use_cassette("files/copy_from_dev_to_stage") do
      response = AcquiaToolbelt::CLI::API.request "sites/devcloud:acquiatoolbeltdev/files-copy/dev/test", "POST", {}, false
    end
  end
end
