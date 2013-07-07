namespace :feeds do

  desc 'fetch all feeds'
  task fetch: :environment do
    Feed.fetch
  end
end
