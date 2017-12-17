json.partial! 'partial/paginate_meta', object: @users
json.items @users do |user|
  json.(user, :id, :email, :nickname, :confirmed_at, :created_at, :current_sign_in_at, :last_sign_in_at)
end