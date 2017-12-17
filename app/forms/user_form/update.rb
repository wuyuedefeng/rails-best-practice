module UserForm
  class Update < Reform::Form
    model :user
    property :nickname
  end
end