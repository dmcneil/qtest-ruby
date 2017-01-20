require_relative 'utils'
require_relative 'project'
require_relative 'release'
require_relative 'test_cycle'
require_relative 'test_run'
require_relative 'test_suite'
require_relative 'test_case'
require_relative 'module'

module QTest
  module REST
    module API
      include HTTParty
      include QTest::REST::Utils
      include QTest::REST::Project
      include QTest::REST::Release
      include QTest::REST::TestCycle
      include QTest::REST::TestRun
      include QTest::REST::TestSuite
      include QTest::REST::TestCase
      include QTest::REST::Module

      BASE_PATH = '/api/v3'

      def self.included(base)
        base.include HTTParty
      end

      # The API token passed in the Authorization header after
      # successfully using the `auth` method.
      attr_accessor :token

      # Authenticate with the QTest REST API using credentials.
      #
      # If successful, an API token is returned and used on future
      # requests.
      #
      # @param opts [Hash]
      # @option username [String] qTest username
      # @option password [String] qTest password
      # @return [String] authorization token
      def auth(opts = {})
        query = QueryBuilder.new
                .options(:without_api_path)
                .with('/api/login')
                .header(:content_type, 'application/x-www-form-urlencoded')
                .data(j_username: opts[:username])
                .data(j_password: opts[:password])
                .build

        @token = post(query, raw: true)
        self.class.send(:headers, 'Authorization' => @token)

        @token
      end

      def fields(opts = {})
        query = QueryBuilder.new
                .project(opts[:project])
                .with(:settings, opts[:type], :fields)
                .build

        get(query)
      end
    end
  end
end
