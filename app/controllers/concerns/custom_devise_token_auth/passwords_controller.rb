module CustomDeviseTokenAuth
  class PasswordsController < DeviseTokenAuth::PasswordsController
    def update
      super
    end
  end
end