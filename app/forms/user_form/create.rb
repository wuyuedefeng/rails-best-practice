require 'reform/form/validation/unique_validator'
module UserForm
  class Create < Reform::Form
    model :user

    property :email
    property :nickname
    property :password

    validates :nickname, :email, :password, presence: true
    validates :email, unique: { case_sensitive: false }, length: { maximum: 60 }, format: { with: CONST::REGEXP_EMAIL }
    validates :password, length: { minimum: 6 }
  end
end