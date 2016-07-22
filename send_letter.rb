require 'httparty'
require 'dotenv'

Dotenv.load

options = {
  body: {
    token: ENV['INCOMING_SLACK_MESSAGE_TOKEN'],
    text: ARGV.first
  }
}

response = HTTParty.post('http://localhost:3000/api/v1/integrations', options)

puts response.body[0..2000]
