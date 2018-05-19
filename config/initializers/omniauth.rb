Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Rails.application.credentials.dig(:development, :github_id), Rails.application.credentials.dig(:development, :github_secret)
end
