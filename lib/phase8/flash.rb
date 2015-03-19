require 'json'
require 'webrick'

module Phase8
  class Flash
    # find the cookie for the flash
    # deserialize the cookie into a hash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app_flash'
          @flash_now_hash = JSON.parse(cookie.value)
        end
      end

      @flash_now_hash ||= {}
      @flash_hash = {}
    end

    def [](key)
      if @flash_now_hash.has_key?(key)
        @flash_now_hash[key]
      else
        @flash_now_hash[key.to_s]
      end
    end

    def []=(key, val)
      @flash_hash[key] = val
    end

    def now
      @flash_now_hash
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_flash(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app_flash', @flash_hash.to_json)
    end
  end
end
