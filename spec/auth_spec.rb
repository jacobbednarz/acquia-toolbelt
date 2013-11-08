require_relative './helper'

describe "when using netrc for authentication" do
  it "should be able to read login values" do
    n = Netrc.read
    n["cloudapi.acquia.com"].should_not be_nil
  end

  it "should have valid users credentials using netrc" do
    setup_authentication
    @acquia_username.should_not be_nil
    @acquia_password.should_not be_nil
  end
end
