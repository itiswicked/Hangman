require 'httparty'

options = {
  body: {
    guess: 'O'
  }
}

response = HTTParty.post('http://localhost:3000/api/v1/integrations', options)

puts response.body[0..4000]
