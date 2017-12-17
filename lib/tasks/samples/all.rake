namespace :samples do
  task all: :environment do
    Rake::Task['samples:admins'].invoke
    Rake::Task['samples:users'].invoke
  end
end
