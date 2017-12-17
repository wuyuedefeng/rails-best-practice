namespace :samples do
  task admins: :environment do
    Admin.find_or_create_by(email: 'admin@phwaimai.com') do |admin|
      admin.password = 'mg123123123'
      admin.confirmed_at = Time.now
    end
  end
end

