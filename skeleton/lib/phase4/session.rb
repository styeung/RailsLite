require 'json'
require 'webrick'

module Phase4
  class Session
    attr_accessor :cookies
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @cookies = {}

      req.cookies.each do |cookie|
        if cookie.name == "_rails_lite_app"
          @cookies = JSON.parse(cookie.value)
          break
        end
      end

      @cookies
    end

    def [](key)
      self.cookies[key]
    end

    def []=(key, val)
      self.cookies[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      new_cookie = WEBrick::Cookie.new('_rails_lite_app', @cookies.to_json)

      res.cookies << new_cookie
    end
  end
end
