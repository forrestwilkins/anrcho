# twitter api

unless ENV['RAILS_ENV'].eql? 'development'
  if ENV['TWITTER_CONSUMER_KEY'].present?
    puts "Twitter API keys found."
  else
    puts "Could not find Twitter API keys."
  end
end

$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
end
