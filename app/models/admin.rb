class Admin < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable,# :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable#, :omniauthable
  include DeviseTokenAuth::Concerns::User
  include Remarkable
  include Footprintable
  has_footprint
end
