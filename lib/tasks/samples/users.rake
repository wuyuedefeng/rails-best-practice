namespace :samples do
  task users: :environment do
    if User.find_by(email: 'user@phwaimai.com').blank?
      user = User.create(email: 'user@phwaimai.com', password: 'mg123123123', confirmed_at: Time.now)
      user.add_role :manager
    end
  end
end
