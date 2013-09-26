require "netrc"
require "faraday"
require "json"

module AcquiaToolbelt
  class CLI
    class API
      USER_AGENT       = "AcquiaToolbelt/#{AcquiaToolbelt::VERSION}"
      ENDPOINT         = "https://cloudapi.acquia.com"
      ENDPOINT_VERSION = "v1"

      def initialize(ui)
        @ui = ui
      end

      # Internal: Build the endpoint URI.
      #
      # By building the URI here, we ensure that it is consistent throughout the
      # application and also allows a single point to update should it be
      # needed.
      #
      # Returns a URI string.
      def endpoint_uri
        "#{AcquiaToolbelt::CLI::API::ENDPOINT}/#{AcquiaToolbelt::CLI::API::ENDPOINT_VERSION}"
      end

      # Internal: Check whether a proxy is in use.
      #
      # Return boolean based on whether HTTPS_PROXY is set.
      def using_proxy?
        ENV["HTTPS_PROXY"] ? true : false
      end

      def self.acquia_api_call(resource, method = "GET", data = {})
        n = Netrc.read
        @acquia_user, @acquia_password = n["cloudapi.acquia.com"]

        # Check if the user is behind a proxy and add the proxy settings if
        # they are.
        conn = (using_proxy?) ? Faraday.new(:proxy => ENV["HTTPS_PROXY"]) : Faraday.new
        conn.basic_auth(@acquia_user, @acquia_password)
        conn.headers["User-Agent"] = "#{AcquiaToolbelt::CLI::API::USER_AGENT}"

        case method
        when "GET"
          response = conn.get "#{endpoint_uri}/#{resource}.json"
          JSON.parse response.body
        when "POST"
          response = conn.post "#{endpoint_uri}/#{resource}.json", data.to_json
          JSON.parse response.body
        when "CODE-DEPLOY-POST"
          response = conn.post "#{endpoint_uri}/#{resource}.json?path=#{data[:release]}"
          JSON.parse response.body
        when "DELETE"
          response = conn.delete "#{endpoint_uri}/#{resource}.json"
          JSON.parse response.body
        else
        end
      end
    end
  end
end
