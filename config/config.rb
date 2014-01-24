# Configuration options can be accessed as
# configatron.site_name
#   don't use symbol for checking environment

configatron.company_name = "Top 5 Project Inc."
configatron.site_name = "theTop5"

configatron.smtp_name = "smtp.gmail.com"
configatron.smtp_port = 587

configatron.omniauth_twitter_key = "5xZ73nb8W87MjN5WPZFGA"
configatron.omniauth_twitter_secret = "LxP23kHDWDGz9Yk4CcvkFUsSy6qwWY7zEvZE2S2fw"
configatron.omniauth_facebook_key = "482813175104715"
configatron.omniauth_facebook_secret = "021ada5ff5a58697446982d2b0dff0db"

unless Rails.env.production?
  # only for :development & :test environment
  configatron.admin_email = "admin@thetop5.com"

  configatron.support_name = "thetop5 support"
  configatron.support_email = "support@thetop5.com"

  if Rails.env.development?
    configatron.site_url = "localhost:3000"
  else
    configatron.site_url = "www.example.com"
  end

  configatron.no_reply_email = "noreply@thetop5.com"
  configatron.no_reply_password = "secret"

else
  configatron.site_url = "166.78.110.209"

  configatron.admin_email = "thetopfive55@gmail.com"
  configatron.admin_email_password = "testing67890z"

  configatron.support_name = "thetop5 support"
  configatron.support_email = "thetopfive55@gmail.com"
  configatron.support_email_password = "testing67890z"

  configatron.no_reply_email = "thetopfive55@gmail.com"
  configatron.no_reply_password = "testing67890z"
end
