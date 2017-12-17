namespace :samples do
  task users: :environment do
    if User.find_by(email: 'user@phwaimai.com').blank?
       User.create(email: 'user@phwaimai.com', password: 'mg123123123', confirmed_at: Time.now)
    end
  end
end
