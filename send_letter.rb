require 'httparty'
options = {
  body: {
    guess: ARGV.first
  }
}

response = HTTParty.post('http://localhost:3000/api/v1/integrations', options)

puts response.body[0..4000]
