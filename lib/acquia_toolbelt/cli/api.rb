require "netrc"
require "faraday"
require "json"
require "acquia_toolbelt/version"

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
      # resource      - The resource URI that is after the version in the API
      #                 URI.
      # method        - HTTP verb to use on the request.
      # data          - Data to send to the endpoint.
      # parse_request - Whether to JSON parse the body before returning or just
      #                 return the whole request object. The whole request is
      #                 returned during tests whereas only the body is required
      #                 for the application.
      #
      # Retuns JSON object from the response body.
      def self.request(resource, method = "GET", data = {}, parse_request = true)
        n = Netrc.read

        # Make sure there is an entry for the Acquia API before generating the
        # requests.
        if n["cloudapi.acquia.com"].nil?
          puts "No entry for cloudapi.acquia.com within your netrc file."
          puts "You can login/reset your user credentials by running `acquia auth:login`"
          return
        end

        @acquia_user, @acquia_password = n["cloudapi.acquia.com"]

        # Check if the user is behind a proxy and add the proxy settings if
        # they are.
        conn = (using_proxy?) ? Faraday.new(:proxy => ENV["HTTPS_PROXY"]) : Faraday.new
        conn.basic_auth(@acquia_user, @acquia_password)

        # Be nice and send a user agent - help tracking and issue detection on
        # Acquia's end as well as the client.
        conn.headers["User-Agent"] = "#{AcquiaToolbelt::CLI::API::USER_AGENT}"

        case method
        when "GET"
          response = conn.get "#{endpoint_uri}/#{resource}.json"

          if parse_request == true
            JSON.parse(response.body)
          else
            response
          end
        when "POST"
          response = conn.post "#{endpoint_uri}/#{resource}.json", data.to_json

          if parse_request == true
            JSON.parse(response.body)
          else
            response
          end
        when "QUERY-STRING-POST"
          response = conn.post "#{endpoint_uri}/#{resource}.json?#{data[:key]}=#{data[:value]}", data.to_json

          if parse_request == true
            JSON.parse(response.body)
          else
            response
          end
        when "DELETE"
          response = conn.delete "#{endpoint_uri}/#{resource}.json"

          if parse_request == true
            JSON.parse(response.body)
          else
            response
          end
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

      # Internal: Show the error message from the response.
      #
      # If the API request fails, this will get the "message" and allow that to
      # be outputted to the end user to be a little more helpful.
      #
      # Returns string of the message.
      def self.display_error(response)
        "Oops, an error occurred!\n\nReason returned from the API: #{response["message"]}"
      end
    end
  end
end
