# rails 5
# 当前请求的用户，可以model使用获取当前用户
module Current
  thread_mattr_accessor :actor
end

# in controler
# around_action :set_thread_current_user
# def set_thread_current_user
#   Current.actor = current_user
#   yield
# ensure
#   # to address the thread variable leak issues in Puma/Thin webserver
#   Current.actor = nil
# end