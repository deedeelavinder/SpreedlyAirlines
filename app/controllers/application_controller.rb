class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  SPREEDLY_KEY = Rails.application.secrets.spreedly_test_key
  SPREEDLY_SECRET = Rails.application.secrets.spreedly_api_secret
  GATEWAY_TOKEN = Rails.application.secrets.gateway_token
  EXPEDIA_TOKEN = Rails.application.secrets.expedia_token

end
