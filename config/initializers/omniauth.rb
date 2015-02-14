Rails.application.config.middleware.use OmniAuth::Builder do
  require "#{Rails.root}/lib/omni_auth/strategies/registr"
  require "#{Rails.root}/lib/oauth2/error"
  provider :registr
end
