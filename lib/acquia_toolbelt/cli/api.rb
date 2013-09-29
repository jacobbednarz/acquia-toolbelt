require "netrc"
require "faraday"
require "json"

module AcquiaToolbelt
  class CLI
    class API
      USER_AGENT       = "AcquiaToolbelt/#{AcquiaToolbelt::VERSION}"
      ENDPOINT         = "https://cloudapi.acquia.com"
      ENDPOINT_VERSION = "v1"

      # Internal: Send a request to the Acquia API.
      #
      # Build a HTTP request to connect to the Acquia API and handle the JSON
      # response accordingly.
      #
      # Retuns JSON object from the response body.
      def self.request(resource, method = "GET", data = {})
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

      # Internal: Get defined subscription environments.
      #
      # This is a helper method that fetches all the available environments for
      # a subscription and returns them for use in other methods.
      #
      # Returns an array of environments.
      def self.get_environments
        subscription = default_subscription
        env_data = request "sites/#{subscription}/envs"

        envs = []
        env_data.each do |env|
          envs << env["name"]
        end

        envs
      end

      # Internal: Use the default environment the user has access to.
      #
      # If the -s (subscription) flag is not set, just use the first
      # subscription the user has access to. This is handy for users that
      # primarily only deal with a specific subscription.
      #
      # Returns the first subscription name.
      def self.default_subscription
        sites = request "sites"
        sites.first
      end

      # Internal: Truncate a SSH key to a secure and recognisable size.
      #
      # Displaying whole SSH keys is probably a bad idea so instead we are
      # getting the first 30 characters and the last 100 characters of the key
      # and separating them with an ellipis. This allows you to recognise the
      # important parts of the key instead of the whole thing.
      #
      # Returns string of the SSH key.
      def self.truncate_ssh_key(ssh_key)
        front_part = ssh_key[0...30]
        back_part  = ssh_key[-50, 50]
        new_ssh_key = "#{front_part}...#{back_part}"
      end

      # Internal: Build the endpoint URI.
      #
      # By building the URI here, we ensure that it is consistent throughout the
      # application and also allows a single point to update should it be
      # needed.
      #
      # Returns a URI string.
      def self.endpoint_uri
        "#{AcquiaToolbelt::CLI::API::ENDPOINT}/#{AcquiaToolbelt::CLI::API::ENDPOINT_VERSION}"
      end

      # Internal: Check whether a proxy is in use.
      #
      # Return boolean based on whether HTTPS_PROXY is set.
      def self.using_proxy?
        ENV["HTTPS_PROXY"] ? true : false
      end
    end
  end
end
