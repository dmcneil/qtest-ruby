module QTest
  class Client
    include HTTParty

    attr_accessor :token

    def configure
      yield self
    end

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
      case response.code
      when 200
        @token = response.body
      when 401
        raise AuthorizationError, "Invalid username/password."
      end
    end

    def base_uri
      self.class.base_uri
    end

    def base_uri=(uri)
      self.class.send(:base_uri, uri)
      @base_uri = uri
    end

    private

    def auth_header
      {'Authorization' => @token}
    end
  end
end
