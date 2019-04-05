require "rubygems"
require 'sinatra'
require "openssl"
require "base64"
require "http"

WEBHOOK_SECRET = ENV['KC_WEBHOOK_SECRET']
TRAVIS_TOKEN = ENV['TRAVIS_TOKEN']
REPO_PATH = ENV['REPO_PATH']&.gsub /\//, "%2F"

URL = "https://api.travis-ci.com/repo/#{REPO_PATH}/requests"
BODY = {
  request: { branch: 'master' }
}
HEADERS = {
  'Content-Type': 'application/json',
  Accept: 'application/json',
  'Travis-API-Version': '3',
  Authorization: "token #{TRAVIS_TOKEN}"
}

def send_regenerate_request
  HTTP
    .headers(HEADERS)
    .post(URL, :json => BODY)
end

def is_signature_valid(given_signature, data)
  hash = OpenSSL::HMAC.digest('sha256', WEBHOOK_SECRET, data)
  calculated_signature = Base64.strict_encode64(hash)

  calculated_signature == given_signature
end

class App < Sinatra::Base
  post "/" do
    request.body.rewind

    data = request.body.read
    signature = env['HTTP_X_KC_SIGNATURE']

    if is_signature_valid signature, data
      send_regenerate_request
    end
  end
end