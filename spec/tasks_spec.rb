describe "tasks" do
  before do
    n = Netrc.read
    @acquia_username, @acquia_password = n["cloudapi.acquia.com"]
  end

  it "response should be an array" do
    VCR.use_cassette("tasks/response_is_an_array") do
      uri = URI("https://cloudapi.acquia.com/v1/sites/devcloud:acquiatoolbeltdev/tasks.json")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth @acquia_username, @acquia_password

      response = http.request(request)
      assert_instance_of Array, JSON.parse(response.body)
    end
  end
end
