require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @session_hash = JSON.parse(cookie.value)
        end
      end
      @session_hash ||= {}
    end

    def [](key)
      @session_hash[key.to_s]
    end

    def []=(key, val)
      @session_hash[key.to_s] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @session_hash.to_json)
    end
  end
end
