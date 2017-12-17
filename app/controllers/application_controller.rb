class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  around_action :set_thread_current_actor

  private

  def set_thread_current_user
    Current.actor = current_user
    yield
  ensure
    # to address the thread variable leak issues in Puma/Thin webserver
    Current.actor = nil
  end
end
