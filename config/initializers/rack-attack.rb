class Rack::Attack
  ### Configure Cache ###

  # If you don't want to use Rails.cache (Rack::Attack's default), then
  # configure it here.
  # default use Rails.cache
  # Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new


  ### Throttle Spammy Clients ###

  # Throttle all requests by IP [一个ip3分钟最多发送180个请求]
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  throttle('req/ip', :limit => 180, :period => 3.minutes) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end

  # Throttle POST requests to /login by IP address [1个ip，20s最多可调用5次登陆接口]
  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
  throttle('logins/ip', :limit => 5, :period => 20.seconds) do |req|
    if req.path == '/login' && req.post?
      req.ip
    end
  end

  ### Custom Throttle Response ###

  # By default, Rack::Attack returns an HTTP 429 for throttled responses,
  # which is just fine.
  #
  # If you want to return 503 so that the attacker might be fooled into
  # believing that they've successfully broken your app (or you just want to
  # customize the response), then uncomment these lines.
  # self.throttled_response = lambda do |env|
  #  [ 503,  # status
  #    {},   # headers
  #    ['']] # body
  # end
end