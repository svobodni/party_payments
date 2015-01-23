Sidekiq.configure_server do |config|
  config.redis = {
    url: 'redis://localhost:6379/2'
    namespace: 'svobodni_finance'
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: 'redis://localhost:6379/2'
    namespace: 'svobodni_finance'
  }
end
