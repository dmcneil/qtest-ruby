require_relative 'utils'
require_relative 'project'
require_relative 'release'
require_relative 'test_cycle'
require_relative 'test_run'

module QTest
  module REST
    module API
      include HTTParty
      include QTest::REST::Utils
      include QTest::REST::Project
      include QTest::REST::Release
      include QTest::REST::TestCycle
      include QTest::REST::TestRun

      attr_accessor :token

      def self.included(base)
        base.include HTTParty
      end

      # Authenticate with the QTest REST API using credentials.
      #
      # If successful, an API token is returned and used on future
      # requests.
      #
      # @param username [String] qTest username
      # @param password [String] qTest password
      def auth(username, password)
        options = {
          headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          },
          body: {
            j_username: username,
            j_password: password
          }
        }

        response = self.class.post("/api/login", options)
        @token = handle_response(response, raw: true)
        self.class.send(:headers, {'Authorization' => @token})
      end
    end
  end
end
