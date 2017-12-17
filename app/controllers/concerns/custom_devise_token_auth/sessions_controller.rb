module CustomDeviseTokenAuth
  class SessionsController < DeviseTokenAuth::SessionsController
    def create
      super do |resource|
        if auth_header resource
          render json: resource.as_json(only: [:email]), status: 200 and return
        else
          render json: {errors: [I18n.t("devise_token_auth.sessions.bad_credentials")]}, status: 401 and return
          # render json: {message: '账号或密码错误'}, status: 401 and return
        end
      end
    end

    def auth_header resource
      true
    end
  end
end