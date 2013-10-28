require 'netrc'

describe "when reading netrc values" do
  it "should be able to read login values" do
    n = Netrc.read
    assert n["cloudapi.acquia.com"], "login values cannot be read or do not exist."
  end
end